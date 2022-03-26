# frozen_string_literal: true

require_relative 'pb/sample_services_pb'

STUB = Sample::FileStorage::Stub.new('localhost:50051', :this_channel_is_insecure)

def upload(file_path)
  file = File.open(file_path)

  # リクエストを作成
  request = Sample::UploadRequest.new

  # リクエストに値を詰めていく
  request.file_name = File.basename(file.path)
  request.file_blob = file.read

  # スタブにリクエストを入れて、gRPC サーバーの rpc を呼び出す。
  response = STUB.upload(request)

  if response.error == 'NO_ERROR'
    puts "アップロード完了 file_name=#{file_name}, created_at=#{response.created_at}"
  else
    puts "アップロード失敗 file_name=#{file_name}, error=#{response.error}"
  end
end

def download(file_name)
  # リクエストを作成
  request = Sample::UploadRequest.new

  # リクエストに値を詰めていく
  request.file_name = file_name

  # Stub にリクエストを入れて、gRPC サーバーの rpc を呼び出す。
  response = STUB.download(request)

  if response.error == 'NO_ERROR'
    File.open(Dir.home + "/Desktop/#{file_name}", 'w') { |f| f.write(response.file_blob) }
    puts "ダウンロード成功 file_name=#{file_name}"
  else
    puts "ダウンロード失敗 file_name=#{file_name}, error=#{response.error}"
  end
end

# コマンドの引数から呼び出すメソッド名とファイルのパス or ファイル名を受け取る
method = ARGV[0]
file_name_or_path = ARGV[1]

raise ArgumentError if %w[upload download].exclude?(method) || file_name.nil?

send(method, file_name_or_path)
