# 📚 Guia de Backup de Arquivos de Mapeamento

## Por que fazer backup?

O arquivo `mapping.txt` é **CRÍTICO** para:
- 🐛 Decodificar stack traces do Firebase Crashlytics
- 📊 Analisar crashes no Google Play Console
- 🔍 Debugar problemas em produção

**Sem este arquivo, crashes aparecerão ofuscados e impossíveis de debugar!**

---

## 🚀 Uso Rápido

### Passo 1: Construir o APK/AAB
```bash
flutter build appbundle --release
```

### Passo 2: Fazer Backup
```bash
./backup-mapping.sh
```

Pronto! ✅ Os arquivos estão salvos em `mapping-backups/vX.X.X_XXX/`

---

## 📋 Workflow Recomendado

### Para cada versão em produção:

1. **Build:**
   ```bash
   flutter build appbundle --release
   ```

2. **Backup Imediato:**
   ```bash
   ./backup-mapping.sh
   ```

3. **Upload no Google Play:**
   - Faça upload do `app-release.aab`
   - Faça upload do `mapping.txt` na mesma tela

4. **Backup em Nuvem (Opcional mas Recomendado):**
   - Copie `mapping-backups/` para Google Drive, Dropbox, etc.

---

## 🔍 Como Recuperar um Mapping

### Cenário: Preciso decodificar um crash da versão 3.4.1

1. **Localizar o backup:**
   ```bash
   cd mapping-backups/v3.4.1_181/
   ```

2. **Usar no Firebase Crashlytics:**
   - Console do Firebase → Crashlytics
   - Clique no crash ofuscado
   - Upload do `mapping.txt`

3. **Usar no Google Play Console:**
   - Deobfuscation files → Upload
   - Selecione `mapping.txt` correspondente

---

## 📂 Estrutura de Diretórios

```
mapping-backups/
├── v3.4.0_180/
│   ├── mapping.txt          # 44 MB - Arquivo principal
│   ├── app-release.aab      # 65 MB - APK de release
│   ├── BUILD_INFO.txt       # Metadados do build
│   ├── configuration.txt    # Configuração do ProGuard
│   └── resources.txt        # Recursos processados
├── v3.4.1_181/
│   └── ...
└── v3.4.2_182/
    └── ...
```

---

## ☁️ Backup em Nuvem

### Google Drive (Recomendado)

**Opção 1: Link Simbólico**
```bash
# Criar pasta no Google Drive
mkdir -p ~/GoogleDrive/MeditaBK-Mappings

# Linkar diretório de backups
rm -rf mapping-backups
ln -s ~/GoogleDrive/MeditaBK-Mappings mapping-backups
```

**Opção 2: Sincronização Manual**
```bash
# Copiar após cada backup
cp -r mapping-backups/* ~/GoogleDrive/MeditaBK-Mappings/
```

### Dropbox

```bash
mkdir -p ~/Dropbox/MeditaBK-Mappings
rm -rf mapping-backups
ln -s ~/Dropbox/MeditaBK-Mappings mapping-backups
```

---

## 🤖 Automação Avançada

### Script de Build + Backup

Crie um alias no seu `~/.zshrc` ou `~/.bashrc`:

```bash
alias flutter-release='flutter build appbundle --release && ./backup-mapping.sh'
```

Agora basta executar:
```bash
flutter-release
```

### Git Hooks (Automático ao criar tags)

Crie `.git/hooks/post-tag`:
```bash
#!/bin/bash
if [[ $1 =~ ^v[0-9]+\.[0-9]+\.[0-9]+$ ]]; then
    echo "Tag de versão criada: $1"
    echo "Fazendo backup do mapping..."
    ./backup-mapping.sh
fi
```

---

## ⚠️ Regras de Ouro

1. **SEMPRE** faça backup ANTES de fazer upload no Google Play
2. **NUNCA** delete backups de versões em produção
3. **SEMPRE** teste se o mapping.txt está correto antes de deletar
4. **Mantenha** pelo menos 10 versões mais recentes
5. **Sincronize** regularmente com serviço de nuvem

---

## 🔐 Segurança

- ✅ `mapping.txt` está no `.gitignore`
- ✅ `mapping-backups/` está no `.gitignore`
- ⚠️ **Não commite** mapping files no Git (são muito grandes!)
- ✅ Use Git LFS se precisar versionar

---

## 📊 Checklist de Release

Antes de publicar cada versão:

- [ ] Build com `flutter build appbundle --release`
- [ ] Executar `./backup-mapping.sh`
- [ ] Verificar `mapping-backups/vX.X.X_XXX/` criado
- [ ] Upload AAB no Google Play
- [ ] Upload mapping.txt no Google Play
- [ ] Copiar backup para nuvem (Google Drive/Dropbox)
- [ ] Verificar no Firebase Crashlytics que novos crashes são decodificáveis

---

## 🆘 Troubleshooting

### "Erro: Arquivo de mapeamento não encontrado"

**Solução:** Execute `flutter build appbundle --release` primeiro!

### "Permission denied"

**Solução:**
```bash
chmod +x backup-mapping.sh
```

### "Backup muito grande"

**Solução:**
- Mapping files são grandes (~40-50MB) - é normal!
- Compacte se necessário: `tar -czf v3.4.1.tar.gz mapping-backups/v3.4.1_181/`

---

## 💡 Dicas Pro

1. **Nomear releases com tags:**
   ```bash
   git tag v3.4.2
   git push origin v3.4.2
   ```

2. **Criar arquivo de changelog junto:**
   ```bash
   echo "v3.4.2 - Correção de bugs" > mapping-backups/v3.4.2_182/CHANGELOG.txt
   ```

3. **Automatizar com cron (backup semanal na nuvem):**
   ```bash
   0 0 * * 0 rsync -av ~/path/to/mapping-backups ~/GoogleDrive/
   ```

---

**Última atualização:** 2026-02-11
**Versão deste guia:** 1.0
