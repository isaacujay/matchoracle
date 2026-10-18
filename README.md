# MatchOracle

Football match outcome predictor: Next.js frontend, FastAPI backend, Supabase (Auth + Postgres).

## Quick start

Backend:

    cd backend
    python -m venv .venv
    .\.venv\Scripts\Activate.ps1
    pip install -r requirements.txt
    uvicorn app.main:app --reload

Frontend (after `npx create-next-app` inside `frontend`):

    cd frontend
    npm install
    npm run dev

Fill in `backend/.env` and `frontend/.env.local` before running. Never commit them.