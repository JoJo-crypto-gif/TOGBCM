# Deployment Guide: Aiven + Render + Netlify

This guide details how to deploy this project using Aiven (for database), Render (for backend API), and Netlify (for frontend).

---

## 1. Database Setup (Aiven)

1. Sign up/log in to [Aiven](https://aiven.io/).
2. Create a new **PostgreSQL** service (Hobbyist or Startup tier).
3. Once running, copy the **Service URI** (connection string). It will look like this:
   `postgres://avnadmin:<PASSWORD>@<HOST>:<PORT>/defaultdb?sslmode=require`
4. Create the `togbc` database:
   - Connect using Beekeeper Studio (using the Service URI above).
   - Run the command: `CREATE DATABASE togbc;`
5. Get the updated connection string targeting `togbc` instead of `defaultdb`:
   `postgres://avnadmin:<PASSWORD>@<HOST>:<PORT>/togbc?sslmode=require`

---

## 2. Backend API Setup (Render)

1. Sign up/log in to [Render](https://render.com/).
2. Create a new **Web Service** and connect it to your GitHub repository: `https://github.com/JoJo-crypto-gif/TOGBCM.git`.
3. Set the following settings:
   - **Root Directory:** `server`
   - **Runtime:** `Node`
   - **Build Command:** `npm install`
   - **Start Command:** `node index.js`
4. Add the following **Environment Variables** in Render:
   - `DATABASE_URL`: `postgres://avnadmin:<PASSWORD>@<HOST>:<PORT>/togbc?sslmode=require`
   - `DATABASE_SSL`: `true`
   - `DATABASE_SSL_REJECT_UNAUTHORIZED`: `false` *(allows self-signed/Aiven CA certs without manual file uploading)*
   - `PORT`: `10000` *(Render binds to this automatically, but good to set)*
   - `NODE_ENV`: `production`
   - `SESSION_SECRET`: *(enter a strong random secret phrase)*
   - `TRUST_PROXY`: `true`
   - `ALLOWED_ORIGINS`: `https://your-app-name.netlify.app` *(update this after creating the Netlify site)*
5. Once deployed, copy your Render Web Service URL (e.g. `https://your-backend.onrender.com`).

---

## 3. Frontend Setup (Netlify)

1. Sign up/log in to [Netlify](https://www.netlify.com/).
2. Create a new site from Git, connect your GitHub repository, and configure:
   - **Root Directory:** `client`
   - **Build Command:** `npm run build`
   - **Publish Directory:** `client/dist` (or `dist` if Netlify automatically resolves it relative to the root directory `client`)
3. Set **Environment Variables** in Netlify:
   - `VITE_API_BASE_URL`: `https://your-backend.onrender.com` *(your actual Render backend URL)*
4. Update the [`client/public/_redirects`](file:///c:/Users/uncle/Desktop/cms/client/public/_redirects) file in your codebase:
   Replace `https://YOUR-RENDER-APP-NAME.onrender.com` with your actual Render URL.
   ```text
   /api/*  https://your-backend.onrender.com/api/:splat  200
   /uploads/*  https://your-backend.onrender.com/uploads/:splat  200
   /*  /index.html  200
   ```
5. Commit and push the updated `_redirects` file to redeploy on Netlify.
