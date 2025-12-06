# Git para Code Review com IA (cola prática)

Guia para trabalhar via **terminal** com branches de PR:

- Ver **quais arquivos foram alterados**
- Ver **o que mudou em cada arquivo**
- Saber diferenciar: alterações locais, na branch, na PR (comparado com `main`)

Vou assumir que:

- Você está em uma branch de feature/PR (ex: `feat/code-review-cli`)
- A branch base é `main` (ou `master`)
- O remoto principal é `origin`

---

## 1. Conceitos rápidos (pra você não se perder)

- `HEAD` → o último commit da branch atual
- `origin/main` → a versão da branch `main` que está no remoto
- `git diff A...B` (com **três pontos**) → compara o trabalho de B em relação a A, usando o ancestral comum (é o mais usado pra PR)
- `git diff A..B` (com **dois pontos**) → diferença direta entre os snapshots de A e B

No contexto de PR, quase sempre você vai usar:

```bash
git diff --name-only origin/main...HEAD
````

> “me mostra os arquivos que mudaram na minha branch em relação à main”.

---

## 2. Ver **quais arquivos foram alterados** (só nomes)

### 2.1. Arquivos alterados na sua working tree (antes do commit)

Alterações ainda não commitadas (entre o que está no disco e o último commit):

```bash
git status
```

Lista geral (modified, staged, untracked).

Se quiser só os nomes dos arquivos com diff em relação ao último commit:

```bash
git diff --name-only
```

- Mostra somente os caminhos dos arquivos que têm alterações **não commitadas**.

Se quiser só o que já foi **adicionado ao stage** (`git add`):

```bash
git diff --cached --name-only
```

---

### 2.2. Arquivos alterados na PR em relação à `main`

Supondo que:

- Você está na branch da PR
- A base é `origin/main`

#### ✅ Todos os arquivos (adicionados, modificados, deletados)

```bash
git diff --name-only origin/main...HEAD
```

#### ✅ Apenas arquivos adicionados ou modificados (ignora deletados)

```bash
git diff --diff-filter=AM --name-only origin/main...HEAD
```

- `A` → Added
- `M` → Modified
  (tem outros: `D` deletado, `R` renomeado etc)

#### ✅ Apenas arquivos com extensão `.rb`

```bash
git diff --name-only origin/main...HEAD -- '*.rb'
```

> OBS: as aspas simples são importantes pro shell não interpretar o `*`.

---

### 2.3. Exemplo completo

```bash
# Garantir que main está atualizada
git fetch origin
git checkout main
git pull origin main

# Voltar pra sua branch da PR
git checkout feat/code-review-cli

# Ver arquivos modificados em relação à main
git diff --diff-filter=AM --name-only origin/main...HEAD
```

Saída exemplo:

```text
lib/reviewrb/core/git_changes.rb
lib/reviewrb/core/reviewer.rb
lib/reviewrb/cli/runner.rb
```

Esses são os arquivos que você pode mandar pra IA analisar.

---

## 3. Ver **o que mudou** em um arquivo específico

Depois de ter o nome do arquivo, você quer ver o diff.

### 3.1. Diff local (em relação ao último commit da branch)

```bash
git diff caminho/do/arquivo.rb
```

Esse comando mostra:

- Linhas removidas com `-`
- Linhas adicionadas com `+`

Exemplo:

```bash
git diff lib/reviewrb/core/reviewer.rb
```

---

### 3.2. Diff da PR (arquivo comparado com `origin/main`)

Se você quer VER o que mudou **na PR** (não só no seu último commit):

```bash
git diff origin/main...HEAD -- lib/reviewrb/core/reviewer.rb
```

ou, se quiser comparar uma branch específica:

```bash
git diff origin/main...feat/code-review-cli -- lib/reviewrb/core/reviewer.rb
```

---

### 3.3. Diferença do que já está staged (no `git add`)

Quando você já deu `git add`, mas quer ver só o que está staged:

```bash
git diff --cached caminho/do/arquivo.rb
```

---

### 3.4. Dicas de leitura de `git diff`

Trecho típico de diff:

```diff
diff --git a/lib/reviewrb/core/reviewer.rb b/lib/reviewrb/core/reviewer.rb
index 8f3b2a1..b1c9f34 100644
--- a/lib/reviewrb/core/reviewer.rb
+++ b/lib/reviewrb/core/reviewer.rb
@@ -10,6 +10,10 @@ module Reviewrb
   module Core
     class Reviewer
       DEFAULT_THREADS = 4
+
+      # Novo comentário explicando a classe
+      # para facilitar o entendimento do fluxo
+
       def initialize(files, threads: DEFAULT_THREADS)
         @files = files
         @threads = threads
```

- Linha começando com `@@` → contexto do bloco (hunk)
- Linhas com `-` → removidas
- Linhas com `+` → adicionadas
- `a/` e `b/` → versão antiga e nova do arquivo

---

## 4. Ver o diff de **todos os arquivos** da PR

Se você quiser uma visão geral do que mudou na PR:

### 4.1. Diff completo da PR

```bash
git diff origin/main...HEAD
```

Isso mostra tudo, arquivo por arquivo.

### 4.2. Diff “resumido” com estatísticas (sem conteúdo)

```bash
git diff --stat origin/main...HEAD
```

Exemplo de saída:

```text
 lib/reviewrb/core/git_changes.rb | 15 +++++++++++++++
 lib/reviewrb/core/reviewer.rb    | 22 +++++++++++-----------
 2 files changed, 26 insertions(+), 11 deletions(-)
```

---

## 5. Ver commits e arquivos alterados por commit

Às vezes você quer olhar commit por commit.

### 5.1. Commits da sua branch em relação à main

```bash
git log --oneline origin/main..HEAD
```

Saída exemplo:

```text
a1b2c3d Implement threaded reviewer
9f8e7d6 Add GitChanges helper
123abcd Initial commit
```

### 5.2. Commits + arquivos alterados

```bash
git log --stat origin/main..HEAD
```

Mostra:

- Commits
- Arquivos alterados em cada commit
- Linhas adicionadas/removidas

---

## 6. Comandos de “cola rápida”

Pra você colar no Notion como checklist:

### 🔹 Listar arquivos alterados na sua PR (comparado com main)

```bash
git diff --name-only origin/main...HEAD
```

### 🔹 Só arquivos adicionados/modificados (ignora deletados)

```bash
git diff --diff-filter=AM --name-only origin/main...HEAD
```

### 🔹 Só arquivos `.rb` alterados na PR

```bash
git diff --name-only origin/main...HEAD -- '*.rb'
```

### 🔹 Ver o que mudou em UM arquivo, na sua branch atual

```bash
git diff caminho/do/arquivo.rb
```

### 🔹 Ver o que mudou em UM arquivo em relação à `origin/main`

```bash
git diff origin/main...HEAD -- caminho/do/arquivo.rb
```

### 🔹 Ver diff completo da PR

```bash
git diff origin/main...HEAD
```

### 🔹 Ver diff resumido com estatísticas

```bash
git diff --stat origin/main...HEAD
```

### 🔹 Ver commits da branch em relação à main

```bash
git log --oneline origin/main..HEAD
```

---

## 7. Como isso entra no teu projeto de IA

Dentro da sua gem de code review, você pode:

1. Rodar `git diff --diff-filter=AM --name-only origin/main...HEAD`
2. Pegar a lista de arquivos
3. Para cada arquivo, rodar:

   - `git diff origin/main...HEAD -- caminho/do/arquivo`
4. Mandar esse diff pro modelo de IA analisar

Isso é exatamente o que uma ferramenta de review automático faria por baixo dos panos.
