<h1 align="center">~ Palm ~</h1>
<p align="center">CLI for PaLM API (Text Generation)</p>

### Installing
**Using `apt` (Debian-based distros)**
1. Import the public key to `/usr/share/keyrings`
```sh
sudo curl -o /usr/share/keyrings/cxmrykk-archive-keyring.gpg https://repo.merrick.cam/pub.gpg
```
2. Save the repository to `/etc/apt/sources.list.d/`
```sh
echo "deb [arch=amd64 signed-by=/usr/share/keyrings/cxmrykk-archive-keyring.gpg] http://repo.merrick.cam/ stable main" \
    | sudo tee /etc/apt/sources.list.d/cxmrykk.list
```
3. Update & install
```sh
sudo apt update && sudo apt install palm
```

### Building
Make sure `crystal` and `git` are installed on the user's system.
```sh
git clone https://github.com/Cxmrykk/PaLM-cli.git
cd PaLM-cli
crystal build ./src/palm.cr
```
This will produce a binary named `palm` in the current directory.

### Executing
```
Usage: palm {flag} [prompt]
    -h, --help                       Shows this message
    -v, --version                    Prints the current version
    -c, --config-path                Prints the path to the configuration file
    -l, --history-path               Prints the path to the history file
    -a, --api-path                   Prints the path to the api configuration file
    -f, --forget                     Forgets the existing conversation (Resets history)
```

### Configuration
Upon first execution, the program will generate a directory in the home folder with three files: `config.json`, `history.json` and `api.json`. Before using the program you will need to supply a valid API key to `api.json`, which you can obtain here: [https://developers.generativeai.google/](https://developers.generativeai.google/)

### Example
```sh
palm "What is the capital of France?"
```
