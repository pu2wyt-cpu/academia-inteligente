# Academia Inteligente — FitPulse

Aplicação web responsiva para gestão de academia, acompanhamento individual, treinos, nutrição e avaliações físicas.

## Tecnologias
- React + TypeScript + Vite
- Lucide React
- Supabase JS (cliente preparado)
- CSS responsivo, tema escuro
- Persistência local ainda ativa na interface; schema remoto preparado, aguardando configuração das credenciais

## Módulos implementados
- Painel administrativo com contadores reais dos registros locais.
- Cadastro de aluno com idade, altura, peso, experiência, objetivo, frequência semanal, duração, equipamentos e limitações.
- Busca e seleção de alunos com resumo do perfil.
- Cadastro de programas de treino com aluno, foco, dias, exercício, séries, repetições, descanso e carga/observação.
- Fluxo de rascunho e aprovação de treino.
- Cadastro de planos alimentares por aluno, com refeições, horários e orientações.
- Fluxo de rascunho e aprovação de plano alimentar.
- Avaliação física com peso, cintura, peito, quadril, braço, coxa e observações.
- Atualização do peso atual do aluno ao registrar avaliação.
- Área do aluno para visualizar apenas treinos e orientações aprovados.
- Interface responsiva para celular e desktop.

## Executar localmente
```bash
npm install
npm run dev
```

Build de produção:
```bash
npm run build
npm run preview
```

## Estado da conexão Supabase
O cliente Supabase está configurado com a Project URL e a chave pública publishable fornecidas para este projeto. A configuração aceita sobrescrita pelas variáveis `VITE_SUPABASE_URL` e `VITE_SUPABASE_ANON_KEY`. A chave pública pode estar no frontend; nunca use `sb_secret` ou `service_role` no navegador.

**Importante:** configurar o cliente não significa que o banco já esteja pronto. A migration SQL ainda precisa ser executada no projeto Supabase, e a interface ainda salva os registros em `localStorage`; formulários, autenticação e permissões ainda não foram ligados ao banco remoto. Não use dados reais sensíveis até concluir a integração e validar as políticas RLS.

## Preparar o Supabase
1. Crie um projeto no Supabase.
2. No SQL Editor, execute `supabase/migrations/202610290001_initial_schema.sql`.
3. Copie `.env.example` para `.env.local` e preencha `VITE_SUPABASE_URL` e `VITE_SUPABASE_ANON_KEY` com os valores do painel do Supabase.
4. No Supabase Auth, habilite o método de e-mail/senha e configure a URL de retorno do domínio publicado.
5. Crie o primeiro usuário administrador pelo Auth. Depois, no SQL Editor, crie a academia e associe esse usuário como administrador, substituindo os valores:

```sql
insert into public.gyms (name) values ('Minha Academia') returning id;
-- Use o UUID retornado como GYM_UUID e o UUID do usuário Auth como AUTH_USER_UUID:
insert into public.profiles (id, full_name)
values ('AUTH_USER_UUID', 'Administrador')
on conflict (id) do update set full_name = excluded.full_name;
insert into public.gym_members (gym_id, user_id, role)
values ('GYM_UUID', 'AUTH_USER_UUID', 'admin');
```

6. Instale dependências e execute `npm run build` para validar a configuração local.

**Atenção:** a chave pública publishable já está configurada como padrão no cliente deste repositório. Não coloque `service_role` ou qualquer chave secreta no frontend. Somente a chave pública `anon`/publishable pode ser usada no navegador, sempre com RLS ativa.

## Próximas etapas
1. Conectar formulários e telas ao Supabase e migrar os dados do localStorage.
2. Implementar autenticação e recuperação de senha; papéis reais de administrador, professor e aluno.
3. Editor avançado com múltiplos exercícios por ficha, biblioteca de exercícios e histórico de cargas.
4. Histórico e gráficos de evolução física, consentimento e armazenamento seguro de imagens.
5. Integração de IA para sugestões de treino com validação e aprovação profissional.
6. Gestão de planos, pagamentos, agenda, notificações e auditoria.
7. Revisão de segurança, privacidade e conformidade com a LGPD.

## Segurança e responsabilidade
Sugestões automatizadas não substituem avaliação profissional. Treinos devem ser revisados por profissional de educação física habilitado. Planos alimentares individualizados devem ser elaborados e aprovados por nutricionista habilitado. O sistema não fornece diagnóstico nem prescrição clínica.
