# 🧝‍♂️ Trilha dos Hobbits — Da Comarca a Mordor

Um aplicativo mobile gamificado desenvolvido em **Flutter** que sincroniza seus passos e distâncias percorridas no mundo real com a lendária jornada de Frodo e Sam pela Terra Média rumo à Montanha da Perdição.

O app correlaciona sua quilometragem real com a minutagem exata da trilogia de filmes *O Senhor dos Anéis* (Edição Estendida), liberando checkpoints narrativos, descrições e cenários conforme você avança.

---

## 🧭 Funcionalidades

- **Sincronização de Passos:** Integração com Google Fit e Health Connect, além de suporte a sensores nativos do dispositivo.
- **Registro Manual Flexível:** Adicione sua atividade a qualquer momento informando **passos** ou **quilômetros** diretamente.
- **Mapa Interativo:** Navegação com gestos de pinça (*pinch-to-zoom*) e visualização dos marcos da rota.
- **Checkpoints com Névoa de Guerra:**
  - *Bloqueados:* Toque para ver apenas a imagem da cena em preto e branco, sem spoilers de minutagem ou texto.
  - *Desbloqueados:* Ao bater a distância, revela a cena colorida, descrição narrativa e a minutagem exata do filme correspondente.
- **Progressão Sequencial:** Os filmes seguintes permanecem trancados até você concluir a distância do filme anterior:
  1. *A Sociedade do Anel* (~740 km canônicos)
  2. *As Duas Torres* (~1.300 km canônicos)
  3. *O Retorno do Rei* (~850 km canônicos)
- **Modos de Dificuldade:**
  - 🟢 **Fácil:** 10% da distância total (~289 km).
  - 🟡 **Médio:** 50% da distância total (~1.445 km).
  - 🔴 **Completo:** 100% da distância canônica (~2.890 km).
- **Registro Histórico Permanente:** A quilometragem total real que você caminhou fica salva para sempre, independente da dificuldade selecionada.
- **Arquitetura Offline-First:** Persistência local segura via Hive/SharedPreferences; funciona perfeitamente sem conexão com a internet.

---

## 📐 Regras de Conversão

- **Média de Passo:** Fixada em `0,75 m` por passo ($\approx 1.333\text{ passos por km}$).
- **Cálculo de Distância:**
  $$\text{distância (km)} = \frac{\text{passos} \times 0{,}75}{1000}$$
- **Cálculo de Passos (Entrada Manual):**
  $$\text{passos} = \frac{\text{distância (km)} \times 1000}{0{,}75}$$

---

## 🛠️ Tecnologias Utilizadas

- **Framework:** [Flutter](https://flutter.dev/)
- **Linguagem:** [Dart](https://dart.dev/)
- **Gerenciamento de Estado:** Bloc / Provider *(ou o de sua preferência)*
- **Saúde e Sensores:** Plugin `health` (Health Connect / Google Fit)
- **Armazenamento Local:** `hive` / `shared_preferences`

---

## 🚀 Como Executar o Projeto

### Pré-requisitos
- Flutter SDK instalado (versão 3.x ou superior)
- Dispositivo Android com depuração USB ativada ou emulador configurado

### Instalação

1. Clone este repositório:
```bash
git clone
