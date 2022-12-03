#!/bin/bash
# ORANGE CC-0 2018 
currentDir=$(dirname $0)
pushd $currentDir
rm sample.tweets
touch sample.tweets
. .newsapikey
[ ! -e "emoji.json" ] && wget -qO emoji.json https://raw.githubusercontent.com/github/gemoji/master/db/emoji.json
[ ! -e "google-10000-english.txt" ] && wget -qO google-10000-english.txt https://raw.githubusercontent.com/first20hours/google-10000-english/master/google-10000-english.txt

curl https://newsapi.org/v2/top-headlines -G \
        -d language=en \
        -d apiKey=$NEWSAPIKEY \
        | tee sample.json

sed -e "s/^/s\/\\\([^a-z]\\\)/Ig" -e "s/$/\\\1 \\\2\/Ig/Ig" -e "s@,@\\\([^a-z]\\\)/ @Ig" filter.csv > filter.patterns
sed -e "s/^/s\/\\\([^a-z]\\\)/Ig" -e "s/$/\\\([^a-z]\\\)\/\\\1 \\\2\/Ig/Ig" <(head -49 google-10000-english.txt) >> filter.patterns
cat numbers.patterns >> filter.patterns


build_corpus(){
    # Clean the input for conceptnet
    local PHRASE=$(printf $1 | tr '[:upper:]' '[:lower:]')
    local OUTPUT=$(mktemp)
    local CORPUS=$(mktemp)
    local JSON=$(mktemp)
    printf "Building corpus for: $PHRASE\n"
    curl -s "http://api.conceptnet.io/c/en/${PHRASE}" -o $JSON
    jq -r '.edges[] | select( .rel.label | test("RelatedTo") ) | .start | select(.language | test("en")) | .label' \
        $JSON 2>/dev/null >  $CORPUS
    jq -r   '.edges[] | select( .rel.label | test("RelatedTo") ) | .end | select(.language | test("en")) | .label' \
        $JSON 2>/dev/null >> $CORPUS
    jq -r   '.edges[] | select( .rel.label | test("Synonym") ) | .start | select(.language | test("en")) | .label' \
        $JSON 2>/dev/null >> $CORPUS
    jq -r     '.edges[] | select( .rel.label | test("Synonym") ) | .end | select(.language | test("en")) | .label' \
        $JSON 2>/dev/null >> $CORPUS
    # Remove duplicate entries
    sed -i -e "/^$PHRASE$/d" $CORPUS
    awk '!seen[$0]++' $CORPUS > $OUTPUT
    cat $OUTPUT
}

search_word(){
        local word=$1
        local OUTPUT=$2
        local TAGS=".[] | select(.tags[] | test(\"^${word}$\")) | .emoji" 
        local EMOJI=".[] | select(.emoji | test(\"${word}\")) | .emoji" 
        local ALIASES=".[] | select(.aliases[] | test(\"^${word}$\")) | .emoji"
        local DESCRIPTION=".[] | select(.description[] | test(\"^${word}$\")) | .emoji"
        # OUTPUT="$OUTPUT$(jq -r "${EMOJI}" raw.json 2>/dev/null | head -1)"   
        OUTPUT="$OUTPUT$(jq -r "${TAGS}" emoji.json 2>/dev/null)" 
        OUTPUT="$OUTPUT$(jq -r "${DESCRIPTION}" emoji.json 2>/dev/null )"
        OUTPUT="$OUTPUT$(jq -r "${ALIASES}" emoji.json 2>/dev/null)" 
        if grep -q "s$" <<< "$word" ; then
            local _word=$(sed -e "s/s$//g" <<< "$word")
            TAGS=".[] | select(.tags[] | test(\"^${_word}$\")) | .emoji" 
            ALIASES=".[] | select(.aliases[] | test(\"^${_word}$\")) | .emoji"
            DESCRIPTION=".[] | select(.description[] | test(\"^${_word}$\")) | .emoji"
            OUTPUT="$OUTPUT$(jq -r "${TAGS}" emoji.json 2>/dev/null)" 
            OUTPUT="$OUTPUT$(jq -r "${DESCRIPTION}" emoji.json 2>/dev/null )"
            OUTPUT="$OUTPUT$(jq -r "${ALIASES}" emoji.json 2>/dev/null)" 
        fi
        echo $OUTPUT
}

to_emoji(){
    local TEMP=$(mktemp)
    local OUTPUT=""
    local wordList=$(mktemp)

    echo "$1" > $TEMP
    
    # We need to fix a few things
    # This needs to be replaced to be more robust to more changes 
    # unicode-range: U+0080-02AF, U+0300-03FF, U+0600-06FF, U+0C00-0C7F, U+1DC0-1DFF, U+1E00-1EFF, U+2000-209F, U+20D0-214F, U+2190-23FF, U+2460-25FF, U+2600-27EF, U+2900-29FF, U+2B00-2BFF, U+2C60-2C7F, U+2E00-2E7F, U+3000-303F, U+A490-A4CF, U+E000-F8FF, U+FE00-FE0F, U+FE30-FE4F, U+1F000-1F02F, U+1F0A0-1F0FF, U+1F100-1F64F, U+1F680-1F6FF, U+1F910-1F96B, U+1F980-1F9E0;
    
    sed \
        -f filter.patterns \
        $TEMP \
        | sed "s/['\"\'\[\]\|]//g;s/ /\n/g;s/.*/\L&/g" \
        | sed -e "/^$/d" -e "s/'//g" \
            > ${wordList}
            # | tee ${wordList} | tr '\n' ' '
    while read word; do
        local _OUTPUT=$OUTPUT
        OUTPUT=$(search_word "$word" "$OUTPUT")
        if [[ "$_OUTPUT" == "$OUTPUT" ]]; then
            while read corpus; do
                OUTPUT=$(search_word "$corpus" "$OUTPUT")
            done < <(build_corpus $word)
        fi
    done < $wordList
    echo $OUTPUT
}

while read entry; do
    # echo $entry
    to_emoji " $entry " | tee -a sample.tweets
done < <(jq -r .articles[].title sample.json | sort -u)
popd
