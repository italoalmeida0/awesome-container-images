#!/bin/bash

echo "========================================="
echo " 🪸 AWECI - Awesome Container Images 🐋 "
echo "             VSCode Server"
echo "========================================="

echo ""
echo "📁 Setting up environment..."
sudo chown -R user:user /home/user
if [ "$(ls -A /home/user)" ]; then
    cp -a /app/home/. /home/user/
    rm /home/user/.bashrc_immutable
fi
[ ! -s "/home/user/.bashrc" ] && cp /etc/skel/.bashrc /home/user/.bashrc
[ ! -f "/home/user/.bash_logout" ] && cp /etc/skel/.bash_logout /home/user/.bash_logout  
[ ! -f "/home/user/.profile" ] && cp /etc/skel/.profile /home/user/.profile

echo ""
echo "🍺 Configuring Homebrew..."
if [ ! -d "/home/user/.homebrew" ] || [ ! -f "/home/user/.homebrew/bin/brew" ]; then
    echo "📦 Copying Homebrew to user directory..."
    cp -r /app/homebrew /home/user/.homebrew
else
    echo "✅ Homebrew already exists in user directory"
fi
echo "🔗 Creating Homebrew symlink..."
sudo mkdir -p /home/linuxbrew
sudo chown -R user:user /home/linuxbrew
ln -sf /home/user/.homebrew /home/linuxbrew/.linuxbrew

echo ""
echo "🐍 Setting up Python virtual environment..."
if [ ! -d "/home/user/.venv" ] ||
   [ ! -f "/home/user/.venv/bin/activate" ];then
    echo "📦 Moving virtual environment to user directory..."
    mv /app/home/.venv /home/user/.venv
else
    echo "✅ Virtual environment already exists"
fi

echo ""
echo "⚙️ Configuring Git..."
GIT_USER_NAME="${GIT_USER_NAME:-Developer}"
GIT_USER_EMAIL="${GIT_USER_EMAIL:-dev@example.com}"

git config --global user.name "$GIT_USER_NAME"
git config --global user.email "$GIT_USER_EMAIL"
git config --global init.defaultBranch main
git config --global pull.rebase false


if [ -S /var/run/docker.sock ]; then
   sudo chmod 666 /var/run/docker.sock 2>/dev/null || true
   echo ""
   echo "🐋 Docker socket configured..."
fi

echo ""
echo "🔧 Setting up shell environment..."
touch /home/user/.bashrc
grep -q "source /app/home/.bashrc_immutable" /home/user/.bashrc || echo "source /app/home/.bashrc_immutable" >> /home/user/.bashrc
source /home/user/.venv/bin/activate

echo ""
echo "🌻🛡️ Installing theme and tools..."
pip install ssh-menu > /dev/null 2>&1 

echo ""
echo "🚀 Starting VSCode..."
code serve-web \
    --host 0.0.0.0 \
    --port ${PORT:-8080} \
    --without-connection-token \
    --accept-server-license-terms \
    ${SERVER_DATA_DIR:+--server-data-dir "$SERVER_DATA_DIR"} \
    ${VERBOSE:+--verbose}