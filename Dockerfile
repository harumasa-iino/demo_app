# Ruby 2.7.6 ベースのDockerイメージを使用
FROM ruby:2.7.6

# Node.jsとYarnをインストール (Webpackerが依存)
RUN apt-get update -qq && apt-get install -y nodejs yarn postgresql-client

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
