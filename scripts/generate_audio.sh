#!/bin/bash
# アルファベット音声生成スクリプト（VOICEVOX使用）
# 事前にVOICEVOXを起動しておくこと: http://localhost:50021

SPEAKER=20  # もち子さん
AUDIO_DIR="./audio"
mkdir -p "$AUDIO_DIR"

generate_wav() {
  local text="$1"
  local output="$2"
  local encoded=$(python3 -c "import urllib.parse; print(urllib.parse.quote('$text'))")
  local query=$(curl -s -X POST "http://localhost:50021/audio_query?speaker=${SPEAKER}&text=${encoded}")
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

# 文字: "letter reading" のペアをスペース区切りで定義
LETTERS="
A エー
B ビー
C シー
D ディー
E イー
F エフ
G ジー
H エイチ
I アイ
J ジェー
K ケー
L エル
M エム
N エヌ
O オー
P ピー
Q キュー
R アール
S エス
T ティー
U ユー
V ブイ
W ダブリュー
X エックス
Y ワイ
Z ゼット
"

while IFS= read -r line; do
  [ -z "$line" ] && continue
  letter=$(echo "$line" | awk '{print $1}')
  reading=$(echo "$line" | awk '{$1=""; print $0}' | sed 's/^ //')
  lower=$(echo "$letter" | tr '[:upper:]' '[:lower:]')
  generate_wav "$reading" "$AUDIO_DIR/${lower}.wav"
done <<< "$LETTERS"

# 褒め言葉
generate_wav "すごい！" "$AUDIO_DIR/sugoi.wav"
generate_wav "やったね！" "$AUDIO_DIR/yattane.wav"
generate_wav "てんさい！" "$AUDIO_DIR/tensai.wav"
generate_wav "かっこいい！" "$AUDIO_DIR/kakkoii.wav"
generate_wav "すばらしい！" "$AUDIO_DIR/subarashii.wav"
generate_wav "やったね！おめでとう！" "$AUDIO_DIR/yattane_big.wav"

echo "=== 完了 ==="
