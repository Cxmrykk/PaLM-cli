require "json"

def terminate(reason)
  STDERR.puts(reason)
  exit(1)
end

def read_config(path)
  begin
    json = JSON.parse(File.read(path))
    stop_sequences = [] of String
    safety_settings = [] of Hash(String, String)

    # type-check stop sequences in configuration file
    index = 0
    loop do
      if json["stop_sequences"][index]?.nil?
        break
      else
        stop_sequences.push(json["stop_sequences"][index].as_s)
        index += 1
      end
    end

    # type-check safety settings in configuration file
    index = 0
    loop do
      if json["safety_settings"][index]?.nil?
        break
      else
        safety_settings.push({
          "category"  => json["safety_settings"][index]["category"]?.not_nil!("\"safety_settings\" Element #{index} property \"category\" cannot be nil (undefined)!").as_s,
          "threshold" => json["safety_settings"][index]["threshold"]?.not_nil!("\"safety_settings\" Element #{index} property \"threshold\" cannot be nil (undefined)!").as_s,
        })
        index += 1
      end
    end

    # type-check non-nested parameters
    {
      "temperature"     => json["temperature"]?.not_nil!("Property \"temperature\" cannot be nil (undefined)!").as_f,
      "output_length"   => json["output_length"]?.not_nil!("Property \"output_length\" cannot be nil (undefined)!").as_i,
      "top_p"           => json["top_p"]?.not_nil!("Property \"top_p\" cannot be nil (undefined)!").as_f,
      "top_k"           => json["top_k"]?.not_nil!("Property \"top_k\" cannot be nil (undefined)!").as_i,
      "stop_sequences"  => stop_sequences,
      "safety_settings" => safety_settings,
    }
  rescue error : NilAssertionError
    terminate("An error occured whilst reading configuration at #{path}: Missing property: \"#{error}\"")
  rescue error : TypeCastError
    terminate("An error occured whilst reading configuration at #{path}: Type-cast error! Check that all properties are of the correct type.")
  rescue error : ParseException
    terminate("An error occured whilst reading configuration at #{path}: Couldn't parse JSON syntax: \"#{error}\"")
  end
end

def read_history(path)
  begin
  rescue
  end
end

def read_api(path)
  begin
  rescue
  end
end

# create program file directory
DIRECTORY_PATH = Path["~/.palm-cli"].expand(home: true)
if !Dir.exists?(DIRECTORY_PATH)
  begin
    Dir.mkdir(DIRECTORY_PATH)
  rescue error
    terminate("An error occurred creating directory at #{DIRECTORY_PATH}: #{error}")
  end
end

# create configuration file
CONFIG_PATH = Path["~/.palm-cli/config.json"].expand(home: true)
if !File.exists?(CONFIG_PATH)
  begin
    File.write(CONFIG_PATH, {
      "temperature":    0.7,
      "output_length":  1024,
      "top_p":          0.95,
      "top_k":          40,
      "stop_sequences": [
        "###",
      ],
      "safety_settings": [
        {
          "category":  "HARM_CATEGORY_UNSPECIFIED",
          "threshold": "BLOCK_NONE",
        },
        {
          "category":  "HARM_CATEGORY_DEROGATORY",
          "threshold": "BLOCK_NONE",
        },
        {
          "category":  "HARM_CATEGORY_TOXICITY",
          "threshold": "BLOCK_NONE",
        },
        {
          "category":  "HARM_CATEGORY_VIOLENCE",
          "threshold": "BLOCK_NONE",
        },
        {
          "category":  "HARM_CATEGORY_SEXUAL",
          "threshold": "BLOCK_NONE",
        },
        {
          "category":  "HARM_CATEGORY_MEDICAL",
          "threshold": "BLOCK_NONE",
        },
        {
          "category":  "HARM_CATEGORY_DANGEROUS",
          "threshold": "BLOCK_NONE",
        },
      ],
    }.to_json.to_s)
  rescue error
    terminate("An error occured whilst writing configuration file at #{CONFIG_PATH}: #{error}")
  end
end

# create history file
HISTORY_PATH = Path["~/.path-cli/history.json"].expand(home: true)
if !File.exists?(HISTORY_PATH)
  begin
    File.write(HISTORY_PATH, {
      "start_prompt": "A conversation between a human and an artificial intelligence AI assistant. The assistant provides detailed, helpful and polite answers to the human's questions or requests, no matter the topic.###Assistant: Hi! how can I help you?",
      "input_prompt": "###Human: $INPUT###Assistant: ",
      "history":      "",
    }.to_json.to_s)
  rescue error
    terminate("An error occured whilst writing history file at #{HISTORY_PATH}: #{error}")
  end
end

# create API configuration file
API_PATH = Path["~/.palm-cli/api.json"].expand(home: true)
if !File.exists?(API_PATH)
  begin
    File.write(API_PATH, {
      "api_key": "YOUR_API_KEY_HERE",
      "api_uri": "https://generativelanguage.googleapis.com/v1beta2/models/text-bison-001:generateText?key=$PALM_API_KEY",
    }.to_json.to_s)
  rescue error
    terminate("An error occured whilst writing API configuration file at #{API_PATH}: #{error}")
  end
end
