# 🚀 Guia de Configuração CI/CD (Google Play + GitHub)

Este guia explica como configurar os pré-requisitos para o deploy automático.

## 1. Google Play Console & Service Account
Para que o GitHub possa subir o app for você, ele precisa de uma "conta de serviço".

1. Acesse o **[Google Cloud Console](https://console.cloud.google.com/)**.
2. Vá em **IAM & Admin > Service Accounts**.
3. Clique em **Create Service Account**.
   - Nome: `github-actions-play-store`
   - Role: `Editor` ou `Project > Browser` (O Google Play Console gerenciará as permissões finas).
4. Após criar, vá na aba **Keys > Add Key > Create New Key > JSON**.
5. Salve esse JSON. Você usará o conteúdo dele no próximo passo.
6. No **[Google Play Console](https://play.google.com/console/)**:
   - Vá em **Configuração > Acesso à API**.
   - Vincule a conta de serviço que você acabou de criar e dê permissão de **Administrador** ou **Release Manager**.

## 2. Gerar Keystore (Assinatura do App)
Se você ainda não tem um keystore de release:

`keytool -genkey -v -keystore ~/upload-keystore.jks -keyalg RSA -keysize 2048 -validity 10000 -alias upload`

- Salve a senha do keystore e a senha da chave.
- Note que no Windows o caminho pode ser diferente (ex: `C:\Users\VOCE\upload-keystore.jks`).

## 3. Configurar Secrets no GitHub
No seu repositório do GitHub, vá em **Settings > Secrets and variables > Actions** e adicione:

| Nome do Secret | Descrição |
| :--- | :--- |
| `ANDROID_KEYSTORE_BASE64` | O conteúdo do arquivo `.jks` convertido para Base64 (`base64 upload-keystore.jks` no terminal). |
| `ANDROID_KEYSTORE_PASSWORD` | Senha do arquivo keystore. |
| `ANDROID_KEY_ALIAS` | O alias que você deu (ex: `upload`). |
| `ANDROID_KEY_PASSWORD` | Senha da chave específica. |
| `PLAY_STORE_CONFIG_JSON` | O conteúdo do arquivo JSON da Service Account que você baixou no passo 1. |

---

> [!TIP]
> **Como converter para Base64 no Windows (PowerShell):**
> `[Convert]::ToBase64String([IO.File]::ReadAllBytes("caminho\para\seu-arquivo.jks"))`
