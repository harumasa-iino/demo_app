# Ruby 2.7.6 ベースのDockerイメージを使用
FROM ruby:2.7.6

# Node.jsとYarnをインストール
RUN apt-get update -qq && apt-get install -y nodejs

# Yarnの公式リポジトリから最新バージョンをインストール
RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - \
 && echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list \
 && apt-get update && apt-get install -y yarn

# Rubygemsを互換性のあるバージョン (3.2.33) にアップデート
RUN gem update --system 3.2.33

# アプリケーションディレクトリを作成
WORKDIR /app

# GemfileとGemfile.lockをコピーして依存関係をインストール
COPY Gemfile /app/Gemfile
COPY Gemfile.lock /app/Gemfile.lock
RUN bundle install

# アプリケーションのソースコードをコピー
COPY . /app

# サーバー起動時にPIDファイルをクリア
CMD ["bash", "-c", "rm -f tmp/pids/server.pid && bundle exec rails s -b '0.0.0.0'"]
