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

# 小文字で渡すことで "capital A" と読み上げられるのを防ぐ
for LETTER in a b c d e f g h i j k l m n o p q r s t u v w x y z; do
  generate_wav "$LETTER" "$AUDIO_DIR/${LETTER}.wav"
done

echo "=== 褒め言葉（英語）==="

generate_wav "Great!" "$AUDIO_DIR/great.wav"
generate_wav "Awesome!" "$AUDIO_DIR/awesome.wav"
generate_wav "Excellent!" "$AUDIO_DIR/excellent.wav"
generate_wav "Well done!" "$AUDIO_DIR/welldone.wav"
generate_wav "Amazing!" "$AUDIO_DIR/amazing.wav"
generate_wav "Great job! You got 5 in a row!" "$AUDIO_DIR/yattane_big.wav"

echo "=== 完了 ==="
