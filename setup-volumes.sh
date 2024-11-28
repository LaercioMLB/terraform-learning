#!/bin/bash

set -e  # Interrompe o script em caso de erro

# Diretórios de backup
backup_dir="/backup"
backup_home="$backup_dir/original_home"
backup_var="$backup_dir/original_var"

# Mapear volumes e pontos de montagem
declare -A volumes=(
  ["/dev/xvdg"]="/shm"
  ["/dev/xvdh"]="/tmp"
  ["/dev/xvdi"]="/home"
  ["/dev/xvdj"]="/var"
  ["/dev/xvdk"]="/var/log"
  ["/dev/xvdl"]="/var/tmp"
  ["/dev/xvdm"]="/opt"
  ["/dev/xvdn"]="swap"
)

# Criar backup
echo "### Etapa 1: Realizando backup ###"
mkdir -p "$backup_home" "$backup_var"

# Backup de /home
if [ -d /home ]; then
  echo "Realizando backup de /home para $backup_home..."
  rsync -av /home/ "$backup_home/"
else
  echo "Diretório /home não encontrado, pulando..."
fi

# Backup de /var
if [ -d /var ]; then
  echo "Realizando backup de /var para $backup_var..."
  rsync -av /var/ "$backup_var/"
else
  echo "Diretório /var não encontrado, pulando..."
fi

echo "Backup concluído!"

# Configurar volumes
echo "### Etapa 2: Configurando volumes ###"
for device in "${!volumes[@]}"; do
  mount_point=${volumes[$device]}

  # Configurar swap
  if [ "$mount_point" == "swap" ]; then
    echo "Configurando swap no dispositivo $device..."
    mkswap "$device"
    swapon "$device"
  else
    # Criar sistema de arquivos e ponto de montagem
    echo "Configurando sistema de arquivos no dispositivo $device..."
    mkfs.ext4 "$device"

    echo "Criando ponto de montagem $mount_point..."
    mkdir -p "$mount_point"

    # Montar e adicionar ao /etc/fstab
    echo "Montando $device em $mount_point..."
    mount "$device" "$mount_point"
    echo "$device $mount_point ext4 defaults 0 2" >> /etc/fstab
  fi
done

# Restaurar dados de backup
echo "### Etapa 3: Restaurando dados dos backups ###"
if [ -d "$backup_home" ]; then
  echo "Restaurando dados para /home..."
  rsync -av "$backup_home/" /home/
fi

if [ -d "$backup_var" ]; then
  echo "Restaurando dados para /var..."
  rsync -av "$backup_var/" /var/
fi

echo "Restauro concluído!"

# Verificar configurações
echo "### Etapa 4: Verificando montagem e swap ###"
mount -a
swapon --show

echo "### Processo concluído com sucesso! ###"