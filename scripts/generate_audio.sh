#!/bin/bash
# アルファベット音声生成スクリプト（VOICEVOX使用）
# 事前にVOICEVOXを起動しておくこと: http://localhost:50021

SPEAKER=20  # もち子さん
AUDIO_DIR="./audio"
mkdir -p "$AUDIO_DIR"

# アルファベットの読み方（日本語）
declare -A LETTER_READINGS
LETTER_READINGS=(
  [A]="エー" [B]="ビー" [C]="シー" [D]="ディー" [E]="イー"
  [F]="エフ" [G]="ジー" [H]="エイチ" [I]="アイ" [J]="ジェー"
  [K]="ケー" [L]="エル" [M]="エム" [N]="エヌ" [O]="オー"
  [P]="ピー" [Q]="キュー" [R]="アール" [S]="エス" [T]="ティー"
  [U]="ユー" [V]="ブイ" [W]="ダブリュー" [X]="エックス" [Y]="ワイ"
  [Z]="ゼット"
)

generate_wav() {
  local text="$1"
  local output="$2"
  local query=$(curl -s -X POST "http://localhost:50021/audio_query?speaker=${SPEAKER}&text=$(python3 -c "import urllib.parse; print(urllib.parse.quote('${text}'))")")
  if [ -z "$query" ]; then
    echo "ERROR: VOICEVOXに接続できません"
    exit 1
  fi
  curl -s -X POST "http://localhost:50021/synthesis?speaker=${SPEAKER}" \
    -H "Content-Type: application/json" \
    -d "$query" \
    -o "$output"
  echo "生成: $output ($text)"
}

echo "=== アルファベット音声生成 ==="

# 各文字のwav生成
for LETTER in "${!LETTER_READINGS[@]}"; do
  READING="${LETTER_READINGS[$LETTER]}"
  generate_wav "$READING" "$AUDIO_DIR/${LETTER,,}.wav"
done

# 褒め言葉
generate_wav "すごい！" "$AUDIO_DIR/sugoi.wav"
generate_wav "やったね！" "$AUDIO_DIR/yattane.wav"
generate_wav "てんさい！" "$AUDIO_DIR/tensai.wav"
generate_wav "かっこいい！" "$AUDIO_DIR/kakkoii.wav"
generate_wav "すばらしい！" "$AUDIO_DIR/subarashii.wav"
generate_wav "やったね！おめでとう！" "$AUDIO_DIR/yattane_big.wav"

echo "=== 完了 ==="
