#!/bin/bash
# アルファベット音声生成スクリプト（macOS say コマンド使用）
# Samantha (en_US) の音声を使用

VOICE="Samantha"
AUDIO_DIR="./audio"
mkdir -p "$AUDIO_DIR"

generate_wav() {
  local text="$1"
  local output="$2"
  local lang="${3:-en}"
  local voice="${4:-$VOICE}"
  local tmp="${output%.wav}.aiff"
  say -v "$voice" "$text" -o "$tmp"
  afconvert -f WAVE -d LEI16@44100 "$tmp" "$output"
  rm "$tmp"
  echo "生成: $output"
}

echo "=== アルファベット音声生成 (Samantha / en_US) ==="

for LETTER in A B C D E F G H I J K L M N O P Q R S T U V W X Y Z; do
  lower=$(echo "$LETTER" | tr '[:upper:]' '[:lower:]')
  generate_wav "$LETTER" "$AUDIO_DIR/${lower}.wav"
done

echo "=== 褒め言葉（日本語）==="

generate_wav "すごい！" "$AUDIO_DIR/sugoi.wav" ja "Kyoko"
generate_wav "やったね！" "$AUDIO_DIR/yattane.wav" ja "Kyoko"
generate_wav "てんさい！" "$AUDIO_DIR/tensai.wav" ja "Kyoko"
generate_wav "かっこいい！" "$AUDIO_DIR/kakkoii.wav" ja "Kyoko"
generate_wav "すばらしい！" "$AUDIO_DIR/subarashii.wav" ja "Kyoko"
generate_wav "やったね！おめでとう！" "$AUDIO_DIR/yattane_big.wav" ja "Kyoko"

echo "=== 完了 ==="
