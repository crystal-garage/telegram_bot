module TelegramBot
  abstract class Bot
    # Returns file metadata and a download path.
    #
    # See: <https://core.telegram.org/bots/api#getfile>
    def get_file(
      file_id : String,
    ) : File
      res = def_force_request(
        "getFile",
        file_id
      )

      File.from_json(res.to_json)
    end

    # Downloads a file returned by Telegram.
    def download(media)
      download(get_file(media.file_id))
    end

    # Downloads a file returned by Telegram.
    def download(file : File)
      file.file_path.try { |path| download(path) }
    end

    # Downloads a file returned by Telegram.
    def download(file_path : String)
      HTTP::Client.get("https://api.telegram.org/file/bot#{@token}/#{file_path}").body
    end
  end
end
