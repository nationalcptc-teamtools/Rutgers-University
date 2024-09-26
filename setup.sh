#!/bin/bash

RED='\033[0;31m'
BLUE='\033[0;36m'
GREEN='\033[0;32m'
NC='\033[0m' # No Color

if [ -z "$1" ]; then
    printf "${RED}Usage: ./setup.sh <User>${NC}"
    exit 1
fi

if [ "$(id -u)" != "0" ]; then
    printf "${RED}Run the script as root${NC}"
    exit 1
fi

printf "${RED}\n\n"
echo ' ██▀███   █    ██   ██████ ▓█████  ▄████▄      ▄████▄   ██▓███  ▄▄▄█████▓ ▄████▄       ██████ ▓█████▄▄▄█████▓ █    ██  ██▓███  '
echo '▓██ ▒ ██▒ ██  ▓██▒▒██    ▒ ▓█   ▀ ▒██▀ ▀█     ▒██▀ ▀█  ▓██░  ██▒▓  ██▒ ▓▒▒██▀ ▀█     ▒██    ▒ ▓█   ▀▓  ██▒ ▓▒ ██  ▓██▒▓██░  ██▒'
echo '▓██ ░▄█ ▒▓██  ▒██░░ ▓██▄   ▒███   ▒▓█    ▄    ▒▓█    ▄ ▓██░ ██▓▒▒ ▓██░ ▒░▒▓█    ▄    ░ ▓██▄   ▒███  ▒ ▓██░ ▒░▓██  ▒██░▓██░ ██▓▒'
echo '▒██▀▀█▄  ▓▓█  ░██░  ▒   ██▒▒▓█  ▄ ▒▓▓▄ ▄██▒   ▒▓▓▄ ▄██▒▒██▄█▓▒ ▒░ ▓██▓ ░ ▒▓▓▄ ▄██▒     ▒   ██▒▒▓█  ▄░ ▓██▓ ░ ▓▓█  ░██░▒██▄█▓▒ ▒'
echo '░██▓ ▒██▒▒▒█████▓ ▒██████▒▒░▒████▒▒ ▓███▀ ░   ▒ ▓███▀ ░▒██▒ ░  ░  ▒██▒ ░ ▒ ▓███▀ ░   ▒██████▒▒░▒████▒ ▒██▒ ░ ▒▒█████▓ ▒██▒ ░  ░'
echo '░ ▒▓ ░▒▓░░▒▓▒ ▒ ▒ ▒ ▒▓▒ ▒ ░░░ ▒░ ░░ ░▒ ▒  ░   ░ ░▒ ▒  ░▒▓▒░ ░  ░  ▒ ░░   ░ ░▒ ▒  ░   ▒ ▒▓▒ ▒ ░░░ ▒░ ░ ▒ ░░   ░▒▓▒ ▒ ▒ ▒▓▒░ ░  ░'
echo '  ░▒ ░ ▒░░░▒░ ░ ░ ░ ░▒  ░ ░ ░ ░  ░  ░  ▒        ░  ▒   ░▒ ░         ░      ░  ▒      ░ ░▒  ░ ░ ░ ░  ░   ░    ░░▒░ ░ ░ ░▒ ░     '
echo '  ░░   ░  ░░░ ░ ░ ░  ░  ░     ░   ░           ░        ░░         ░      ░           ░  ░  ░     ░    ░       ░░░ ░ ░ ░░       '
echo '   ░        ░           ░     ░  ░░ ░         ░ ░                        ░ ░               ░     ░  ░           ░              '
echo '                                  ░           ░                          ░                                                      '
printf "${NC}"

printf "${BLUE}"

echo '   ___         ___      ______     __        '
echo '  / _ )__ __  / _ \__ _/_  __/__ _/ /__  ___ '
echo ' / _  / // / / // /\ \ // / / _ `/ / _ \/ _ \'
echo '/____/\_, /  \___//_\_\/_/  \_,_/_/\___/_//_/'
echo '     /___/                                   '

printf "${NC}\n"

sleep 2

SCRIPT_DIR="$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"

progress_bar() {
    local progress=$1
    local total=$2
    local columns=$(tput cols)
    local percent=$((progress * 100 / total))
    local bar_width=$((columns - 10))
    local done=$((percent * bar_width / 100))
    local left=$((bar_width - done))
    
    printf "\r${GREEN}["
    printf "%0.s#" $(seq 1 $done)
    printf "%0.s-" $(seq 1 $left)
    printf "] %3d%%" "$percent"
    printf "${NC}"
}

total_steps=40
current_step=0

cp "p10k.zsh" "$path/.p10k.zsh"
cp "p10k.zsh" "/root/.p10k.zsh"

path="/home/$1"

if [ ! -d "$path/Desktop/Tools" ]; then
    mkdir -p "$path/Desktop/Tools"
    if [ $? -ne 0 ]; then
        printf "\n${RED}Failed to create directory: $path/Desktop/Tools${NC}"
        exit 1
    fi
fi

cd "$path/Desktop/Tools" || { printf "\n${RED}Failed to change directory to $path/Desktop/Tools${NC}"; exit 1; }

echo "export PATH=\$PATH:/usr/.local/bin" >> "$path/.zshrc"

printf "\n\n${BLUE}Installing Dependencies${NC}\n\n"

apt install wget curl git golang rustup musl-tools gcc-mingw-w64 python3 python3-pip python3.12-venv python3-xlsxwriter docker.io docker-compose pipx xclip -y >>$path/setup.log 2>>$path/error.log
current_step=$((current_step + 1))
progress_bar $current_step $total_steps
current_step=$((current_step + 1))
progress_bar $current_step $total_steps
if [ $? -ne 0 ]; then
    printf "\n${RED}Failed to install dependencies${NC}\n"
    exit 1
fi

rustup default stable >>$path/setup.log 2>>$path/error.log


sleep 2


printf "\n\n${BLUE}Installing Active Directory Suite${NC}\n\n"

sleep 1

apt install crackmapexec bloodhound.py ldap-utils faketime ntpsec-ntpdate neo4j bloodhound -y >>$path/setup.log 2>>$path/error.log
current_step=$((current_step + 1))
progress_bar $current_step $total_steps

mkdir -p "$path/Desktop/Tools/windows-binaries/"

# Kerbrute -> /usr/local/bin/kerbrute
wget https://github.com/ropnop/kerbrute/releases/download/v1.0.3/kerbrute_linux_amd64 -O kerbrute >>$path/setup.log 2>>$path/error.log && \
current_step=$((current_step + 1))
progress_bar $current_step $total_steps
chmod +x kerbrute && \
mv kerbrute "/usr/local/bin/"

pipx_tools=(
    "git+https://github.com/Pennyw0rth/NetExec"
    "git+https://github.com/ThePorgs/impacket"
    "git+https://github.com/dirkjanm/ldapdomaindump"
    "git+https://github.com/CravateRouge/bloodyAD"
    "git+https://github.com/r0oth3x49/ghauri"
    "git+https://github.com/arthaud/git-dumper"
    "rpcclient"
)

for tool in "${pipx_tools[@]}"; do
    sudo -H -u $1 pipx install "$tool" >>$path/setup.log 2>>$path/error.log
current_step=$((current_step + 1))
progress_bar $current_step $total_steps
done

sudo -H -u $1 pipx ensurepath >>$path/setup.log 2>>$path/error.log

git clone https://github.com/theyoge/AD-Pentesting-Tools.git >>$path/setup.log 2>>$path/error.log
current_step=$((current_step + 1))
progress_bar $current_step $total_steps
git clone https://github.com/r3motecontrol/Ghostpack-CompiledBinaries.git >>$path/setup.log 2>>$path/error.log
current_step=$((current_step + 1))
progress_bar $current_step $total_steps
git clone https://github.com/expl0itabl3/Toolies.git >>$path/setup.log 2>>$path/error.log
current_step=$((current_step + 1))
progress_bar $current_step $total_steps

git clone https://github.com/Greenwolf/ntlm_theft.git >>$path/setup.log 2>>$path/error.log && \
current_step=$((current_step + 1))
progress_bar $current_step $total_steps
cd ntlm_theft && \
chmod +x ntlm_theft.py && \
mv ntlm_theft.py "/usr/local/bin/ntlm_theft" && \
cd "$path/Desktop/Tools" && \
rm -rf ntlm_theft

git clone https://github.com/topotam/PetitPotam.git >>$path/setup.log 2>>$path/error.log && \
current_step=$((current_step + 1))
progress_bar $current_step $total_steps
cd PetitPotam && \
chmod +x PetitPotam.py && \
mv PetitPotam.py "/usr/local/bin/petitpotam" && \
mv PetitPotam.exe "$path/Desktop/Tools/windows-binaries/" && \
cd ../ && \
rm -rf PetitPotam

printf "\n\n${BLUE}Installing Windows Tools${NC}\n\n"

sleep 1

apt install smbclient enum4linux smbmap nbtscan evil-winrm freerdp3-x11 xtightvncviewer rdesktop mimikatz windows-binaries kali-tools-windows-resources -y >>$path/setup.log 2>>$path/error.log
current_step=$((current_step + 1))
progress_bar $current_step $total_steps

wget https://github.com/antonioCoco/RunasCs/releases/download/v1.5/RunasCs.zip >>$path/setup.log 2>>$path/error.log && \
current_step=$((current_step + 1))
progress_bar $current_step $total_steps
unzip RunasCs.zip >>$path/setup.log 2>>$path/error.log && \
rm RunasCs.zip && \
chmod +x RunasCs* && \
mv RunasCs* "$path/Desktop/Tools/windows-binaries/"

printf "\n\n${BLUE}Installing Email Tools${NC}\n\n"

sleep 1

apt install ismtp smtp-user-enum swaks -y >>$path/setup.log 2>>$path/error.log
current_step=$((current_step + 1))
progress_bar $current_step $total_steps

printf "\n\n${BLUE}Installing Web Tools${NC}\n\n"

sleep 1

PYTHONWARNINGS="ignore::SyntaxWarning" apt install burpsuite exploitdb nikto zaproxy wpscan whatweb wafw00f xsser sqlmap ffuf gobuster feroxbuster hydra medusa theharvester sublist3r amass cewl crunch -y >>$path/setup.log 2>>$path/error.log
current_step=$((current_step + 1))
progress_bar $current_step $total_steps

printf "\n\n${BLUE}Installing Hash Cracking Tools${NC}\n\n"

sleep 1

apt install hashcat john name-that-hash gpp-decrypt wordlists seclists -y >>$path/setup.log 2>>$path/error.log

rockyou_txt="/usr/share/wordlists/rockyou.txt"
rockyou_gz="/usr/share/wordlists/rockyou.txt.gz"

if [ -f "$rockyou_txt" ]; then
    echo "rockyou.txt is already present." >>$path/setup.log
else
    if [ -f "$rockyou_gz" ]; then
        echo "rockyou.txt.gz found. Unzipping..." >>$path/setup.log
        gzip -d "$rockyou_gz" >>$path/setup.log 2>>$path/error.log
    else
        echo "\n${RED}Neither rockyou.txt nor rockyou.txt.gz is present.${NC}" 2>>$path/error.log
    fi
fi

current_step=$((current_step + 1))
progress_bar $current_step $total_steps

printf "\n\n${BLUE}Installing Network Tools${NC}\n\n"

sleep 1

apt install socat netcat-traditional ncat rlwrap tshark dnsrecon netdiscover nmap responder mitm6 arp-scan autorecon proxychains4 -y >>$path/setup.log 2>>$path/error.log
current_step=$((current_step + 1))
progress_bar $current_step $total_steps

printf "\n\n${BLUE}Installing Proxies${NC}\n\n"

sleep 1

mkdir -p "$path/Desktop/Tools/Proxies"
mkdir -p "$path/Desktop/Tools/Proxies/chisel"
mkdir -p "$path/Desktop/Tools/Proxies/ligolo"

# Ligolo-ng -> /usr/local/bin/ligolo-ng

wget https://github.com/nicocha30/ligolo-ng/releases/download/v0.7.2-alpha/ligolo-ng_proxy_0.7.2-alpha_linux_amd64.tar.gz >>$path/setup.log 2>>$path/error.log && \
current_step=$((current_step + 1))
progress_bar $current_step $total_steps
tar -xvf ligolo-ng_proxy_0.7.2-alpha_linux_amd64.tar.gz >>$path/setup.log 2>>$path/error.log && \
rm README.md LICENSE ligolo-ng_proxy_0.7.2-alpha_linux_amd64.tar.gz && \
chmod +x proxy && \
mv proxy "/usr/local/bin/ligolo-ng"


# ligolo-ng agents -> /Tools/Proxies/ligolo/winagent.exe and linagent

 # winagent.exe

wget https://github.com/nicocha30/ligolo-ng/releases/download/v0.7.2-alpha/ligolo-ng_agent_0.7.2-alpha_windows_amd64.zip >>$path/setup.log 2>>$path/error.log && \
current_step=$((current_step + 1))
progress_bar $current_step $total_steps
unzip ligolo-ng_agent_0.7.2-alpha_windows_amd64.zip >>$path/setup.log 2>>$path/error.log && \
rm README.md LICENSE ligolo-ng_agent_0.7.2-alpha_windows_amd64.zip && \
chmod +x agent.exe && \
mv agent.exe "$path/Desktop/Tools/Proxies/ligolo/winagent.exe"

 # linagent

wget https://github.com/nicocha30/ligolo-ng/releases/download/v0.7.2-alpha/ligolo-ng_agent_0.7.2-alpha_linux_amd64.tar.gz >>$path/setup.log 2>>$path/error.log && \
current_step=$((current_step + 1))
progress_bar $current_step $total_steps
tar -xvf ligolo-ng_agent_0.7.2-alpha_linux_amd64.tar.gz >>$path/setup.log 2>>$path/error.log && \
rm README.md LICENSE ligolo-ng_agent_0.7.2-alpha_linux_amd64.tar.gz && \
chmod +x agent && \
mv agent "$path/Desktop/Tools/Proxies/ligolo/linagent"


# Chisel -> /usr/local/bin/chisel

wget https://github.com/jpillora/chisel/releases/download/v1.10.0/chisel_1.10.0_linux_amd64.deb >>$path/setup.log 2>>$path/error.log && \
current_step=$((current_step + 1))
progress_bar $current_step $total_steps
dpkg -i chisel_1.10.0_linux_amd64.deb >>$path/setup.log 2>>$path/error.log && \
rm chisel_1.10.0_linux_amd64.deb && \
mv "/usr/bin/chisel" "/usr/local/bin/"


# Chisel clients -> /Tools/Proxies/chisel/winclient.exe and linclient

 # chisel.exe

wget https://github.com/jpillora/chisel/releases/download/v1.10.0/chisel_1.10.0_windows_amd64.gz -O chisel.exe.gz >>$path/setup.log 2>>$path/error.log && \
current_step=$((current_step + 1))
progress_bar $current_step $total_steps
gzip -d chisel.exe.gz >>$path/setup.log 2>>$path/error.log && \
chmod +x chisel.exe && \
mv chisel.exe "$path/Desktop/Tools/Proxies/chisel/"

 # chisel

cp "/usr/local/bin/chisel" "$path/Desktop/Tools/Proxies/chisel/"


printf "\n\n${BLUE}Grabbing Privesc Scripts${NC}\n\n"

sleep 1

mkdir -p "$path/Desktop/Tools/Priv"

# linpeas

 # sh script
wget https://github.com/peass-ng/PEASS-ng/releases/latest/download/linpeas.sh >>$path/setup.log 2>>$path/error.log && \
current_step=$((current_step + 1))
progress_bar $current_step $total_steps
chmod +x linpeas.sh && \
mv linpeas.sh "$path/Desktop/Tools/Priv/"

 # binary
wget https://github.com/peass-ng/PEASS-ng/releases/download/20240915-f58aa30b/linpeas_linux_amd64 >>$path/setup.log 2>>$path/error.log && \
current_step=$((current_step + 1))
progress_bar $current_step $total_steps
chmod +x linpeas_linux_amd64 && \
mv linpeas_linux_amd64 "$path/Desktop/Tools/Priv/linpeas"

# winpeas

 # x64 exe
wget https://github.com/peass-ng/PEASS-ng/releases/download/20240915-f58aa30b/winPEASx64.exe >>$path/setup.log 2>>$path/error.log && \
current_step=$((current_step + 1))
progress_bar $current_step $total_steps
chmod +x winPEASx64.exe && \
mv winPEASx64.exe "$path/Desktop/Tools/Priv/winpeasx64.exe"

 # x86 exe
wget https://github.com/peass-ng/PEASS-ng/releases/download/20240915-f58aa30b/winPEASx86.exe >>$path/setup.log 2>>$path/error.log && \
current_step=$((current_step + 1))
progress_bar $current_step $total_steps
chmod +x winPEASx86.exe && \
mv winPEASx86.exe "$path/Desktop/Tools/Priv/winpeasx86.exe"

 # batch file
wget https://github.com/peass-ng/PEASS-ng/releases/download/20240915-f58aa30b/winPEAS.bat >>$path/setup.log 2>>$path/error.log && \
current_step=$((current_step + 1))
progress_bar $current_step $total_steps
chmod +x winPEAS.bat && \
mv winPEAS.bat "$path/Desktop/Tools/Priv/winpeas.bat"


# bloodyAD windows exe
wget https://github.com/CravateRouge/bloodyAD/releases/download/v2.0.6/bloodyAD.exe >>$path/setup.log 2>>$path/error.log && \
current_step=$((current_step + 1))
progress_bar $current_step $total_steps
chmod +x bloodyAD.exe && \
mv bloodyAD.exe "$path/Desktop/Tools/windows-binaries/"


printf "\n\n${BLUE}Installing Cloud Tools${NC}\n\n"

sleep 1

curl -s https://packages.microsoft.com/keys/microsoft.asc 2>>$path/error.log | apt-key add - >>$path/setup.log 2>>$path/error.log

wget -q https://packages.microsoft.com/config/debian/12/packages-microsoft-prod.deb >>$path/setup.log 2>>$path/error.log && \
current_step=$((current_step + 1))
progress_bar $current_step $total_steps
dpkg -i packages-microsoft-prod.deb >>$path/setup.log 2>>$path/error.log && \
rm packages-microsoft-prod.deb && \
apt update -y >>$path/setup.log 2>>$path/error.log

PYTHONWARNINGS="ignore::SyntaxWarning" apt install awscli azure-cli powershell -y >>$path/setup.log 2>>$path/error.log
current_step=$((current_step + 1))
progress_bar $current_step $total_steps

printf "\n\n${BLUE}Installing Command and Control Frameworks and Payload Generation${NC}\n\n"

sleep 2

apt install metasploit-framework armitage powershell-empire starkiller havoc redeye -y >>$path/setup.log 2>>$path/error.log
current_step=$((current_step + 1))
progress_bar $current_step $total_steps

curl -s https://sliver.sh/install 2>>$path/error.log | sudo bash >>$path/setup.log 2>>$path/error.log

git clone https://github.com/spellshift/realm.git >>$path/setup.log 2>>$path/error.log
current_step=$((current_step + 1))
progress_bar $current_step $total_steps

# payload generation for realm (imix)

#rustup target add x86_64-unknown-linux-musl
#cd "$path/Desktop/Tools/realm/implants/imix/"
#RUSTFLAGS="-C target-feature=+crt-static" cargo build --release --target=x86_64-unknown-linux-musl
#
#rustup target add x86_64-pc-windows-gnu
#RUSTFLAGS="-C target-feature=+crt-static" cargo build --release --target=x86_64-pc-windows-gnu
#RUSTFLAGS="-C target-feature=+crt-static" cargo build --release --features win_service --target=x86_64-pc-windows-gnu
#RUSTFLAGS="-C target-feature=+crt-static" cargo build --release --lib --target=x86_64-pc-windows-gnu

cd "$path/Desktop/"

chown -hR $1:$1 Tools

# Tools Complete

printf "\n\n${BLUE}Installing/Configuring Oh-My-Zsh + Plugins and P10K${NC}\n\n"
sleep 1

mkdir -p "$path/Desktop/zshresources"
if [ $? -ne 0 ]; then
    printf "\n${RED}Failed to create zshresources directory${NC}\n"
    exit 1
fi

cd "$path/Desktop/zshresources" || { printf "\n${RED}Failed to change directory to zshresources${NC}\n"; exit 1; }

wget https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh >>$path/setup.log 2>>$path/error.log
current_step=$((current_step + 1))
progress_bar $current_step $total_steps
if [ $? -ne 0 ]; then
    printf "\n${RED}Failed to download Oh-My-Zsh install script${NC}\n"
    exit 1
fi

chown -hR $1:$1 "$path/Desktop/zshresources"

sleep 1

sudo -H -u $1 sh install.sh --unattended >>$path/setup.log 2>>$path/error.log
if [ $? -ne 0 ]; then
    printf "\n${RED}Failed to install Oh-My-Zsh for user $1${NC}\n"
    exit 1
fi

sh install.sh --unattended >>$path/setup.log 2>>$path/error.log
if [ $? -ne 0 ]; then
    printf "\n${RED}Failed to install Oh-My-Zsh for root${NC}\n"
    exit 1
fi

git clone --depth=1 https://github.com/romkatv/powerlevel10k.git "${ZSH_CUSTOM:-$path/.oh-my-zsh/custom}/themes/powerlevel10k" >>$path/setup.log 2>>$path/error.log
current_step=$((current_step + 1))
progress_bar $current_step $total_steps
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git "${ZSH_CUSTOM:-/root/.oh-my-zsh/custom}/themes/powerlevel10k" >>$path/setup.log 2>>$path/error.log
current_step=$((current_step + 1))
progress_bar $current_step $total_steps

theme='ZSH_THEME="powerlevel10k/powerlevel10k"'
sed -i "11s|.*|${theme}|" "/root/.zshrc"
sed -i "11s|.*|${theme}|" "${path}/.zshrc"

echo '[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh' >> "$path/.zshrc"
echo '[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh' >> "/root/.zshrc"

current_step=$((current_step + 1))
progress_bar $current_step $total_steps

autosuggestions_setup() {
    user_home=$1
    git clone https://github.com/zsh-users/zsh-autosuggestions "$user_home/.zsh/zsh-autosuggestions" >>$path/setup.log 2>>$path/error.log
    current_step=$((current_step + 1))
    progress_bar $current_step $total_steps
    echo "source $user_home/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh" >> "$user_home/.zshrc"
}

autosuggestions_setup "$path"
autosuggestions_setup "/root"

apt install zsh-syntax-highlighting -y >>$path/setup.log 2>>$path/error.log
current_step=$((current_step + 1))
progress_bar $current_step $total_steps
if [ $? -ne 0 ]; then
    printf "\n${RED}Failed to install zsh-syntax-highlighting${NC}\n"
    exit 1
fi

echo "source /usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" >> "${ZDOTDIR:-$path/.zshrc}"
echo "source /usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" >> "${ZDOTDIR:-/root/.zshrc}"

echo "source $SCRIPT_DIR/aliases.zsh" >> "${ZDOTDIR:-$path/.zshrc}"
echo "source $SCRIPT_DIR/aliases.zsh" >> "${ZDOTDIR:-/root/.zshrc}"

git clone https://github.com/zsh-users/zsh-completions "${ZSH_CUSTOM:-${ZSH:-$path/.oh-my-zsh}/custom}/plugins/zsh-completions" >>$path/setup.log 2>>$path/error.log
current_step=$((current_step + 1))
progress_bar $current_step $total_steps
git clone https://github.com/zsh-users/zsh-completions "${ZSH_CUSTOM:-${ZSH:-/root/.oh-my-zsh}/custom}/plugins/zsh-completions" >>$path/setup.log 2>>$path/error.log
current_step=$((current_step + 1))
progress_bar $current_step $total_steps

new_line="fpath+=${ZSH_CUSTOM:-${ZSH:-${path}/.oh-my-zsh}/custom}/plugins/zsh-completions/src"
search_phrase="source \$ZSH/oh-my-zsh.sh"
escaped_search_phrase=$(echo "$search_phrase" | sed 's/\//\\\//g')
sed -i "/${escaped_search_phrase}/i ${new_line}" /root/.zshrc

new_line="fpath+=${ZSH_CUSTOM:-${ZSH:-/root/.oh-my-zsh}/custom}/plugins/zsh-completions/src"
sed -i "/${escaped_search_phrase}/i ${new_line}" ${path}/.zshrc

echo "export PATH=\$PATH:/home/$1/.local/bin" >> "$path/.zshrc"
echo "export PATH=\$PATH:/root/.local/bin" >> "/root/.zshrc"

apt autoremove -y >>$path/setup.log 2>>$path/error.log
apt autoclean -y >>$path/setup.log 2>>$path/error.log

printf "\n\n\n\n${GREEN}Installation Complete! Happy PWNing!${NC}\n"
