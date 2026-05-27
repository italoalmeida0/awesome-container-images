#!/bin/bash

echo "========================================="
echo " 🪸 AWECI - Awesome Container Images 🐋 "
echo "           Jupyter Lab Server"
echo "========================================="

echo ""
echo "📁 Setting up environment..."
sudo chown -R user:user /home/user
if [ "$(ls -A /home/user)" ]; then
    cp -an /app/home/. /home/user/
    rm -f /home/user/.bashrc_immutable 2>/dev/null || true
fi
[ ! -f "/home/user/.bashrc" ] && cp /etc/skel/.bashrc /home/user/.bashrc
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
   [ ! -f "/home/user/.venv/bin/activate" ] ||
   [ ! -f "/home/user/.venv/bin/jupyter" ];then
    echo "📦 Moving virtual environment to user directory..."
    mv /app/home/.venv /home/user/.venv
else
    echo "✅ Virtual environment already exists"
fi

echo ""
echo "⚙️  Configuring Jupyter Lab..."
mkdir -p "/home/user/.jupyter"
if [ ! -s "/home/user/.jupyter/jupyter_lab_config.py" ]; then
    echo "📝 Creating Jupyter SHELL configuration..."
    cat > "/home/user/.jupyter/jupyter_lab_config.py" << 'EOF'
c.ServerApp.terminado_settings = {
    'shell_command': ['/bin/bash', '-l']
}
EOF
else
    echo "✅ Jupyter Lab configuration already exists"
fi

echo ""
echo "🔧 Setting up shell environment..."
touch /home/user/.bashrc
grep -q "source /app/home/.bashrc_immutable" /home/user/.bashrc || echo "source /app/home/.bashrc_immutable" >> /home/user/.bashrc
source /home/user/.venv/bin/activate

echo ""
echo "🌻🛡️ Installing theme and tools..."
pip install ssh-menu > /dev/null 2>&1 
pip install catppuccin-jupyterlab > /dev/null

echo ""
echo "🚀 Starting Jupyter Lab..."
jupyter lab \
    --ip=0.0.0.0 \
    --port=${PORT:-8080} \
    --no-browser \
    --notebook-dir=/home/user \
    --ServerApp.token='' \
    --ServerApp.password='' \
    --ServerApp.disable_check_xsrf=True