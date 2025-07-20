# Railway Deployment Setup Guide

## 🚀 **Step 1: Create PostgreSQL Database on Railway**

1. **Go to Railway Dashboard**: https://railway.app/dashboard
2. **Create New Project** or use existing project
3. **Add PostgreSQL Database**:
   - Click "New Service"
   - Select "Database" → "PostgreSQL"
   - Wait for database to be created

## 🔧 **Step 2: Set Environment Variables**

After creating the PostgreSQL database, Railway will automatically set these environment variables:

### **Required Environment Variables:**

```bash
# Database Configuration (Auto-set by Railway)
PGHOST=postgres.railway.internal
PGPORT=5432
PGDATABASE=railway
PGUSER=postgres
PGPASSWORD=your_password_here

# Application Configuration (Set manually)
JWT_SECRET=your-super-secret-jwt-key-change-this
PORT=8080
```

### **How to Set Environment Variables:**

1. **In Railway Dashboard**:
   - Go to your project
   - Click on your service (not the database)
   - Go to "Variables" tab
   - Add the following variables:

```
JWT_SECRET=your-super-secret-jwt-key-change-this
```

2. **Or via Railway CLI**:
   ```bash
   railway variables set JWT_SECRET=your-super-secret-jwt-key-change-this
   ```

## 🔍 **Step 3: Verify Database Connection**

The application will automatically use Railway's PostgreSQL environment variables:

- `PGHOST` → Database host
- `PGPORT` → Database port  
- `PGDATABASE` → Database name
- `PGUSER` → Database username
- `PGPASSWORD` → Database password

## 🚀 **Step 4: Deploy**

1. **Push to GitHub**:
   ```bash
   git add .
   git commit -m "Fix Railway database connection"
   git push origin main
   ```

2. **Railway will auto-deploy** when it detects changes

## 🔍 **Step 5: Check Logs**

If you still have issues, check the Railway logs:

1. Go to Railway Dashboard
2. Click on your service
3. Go to "Deployments" tab
4. Click on the latest deployment
5. Check the logs for database connection details

## 🛠️ **Troubleshooting**

### **Issue: "could not translate host name"**
- **Solution**: Make sure you have a PostgreSQL database service in your Railway project
- **Check**: Go to Railway dashboard → Your project → Services → Should see PostgreSQL

### **Issue: "Connection refused"**
- **Solution**: Wait for database to fully initialize (can take 1-2 minutes)
- **Check**: Railway dashboard → Database service → Should show "Running" status

### **Issue: "Authentication failed"**
- **Solution**: Railway automatically sets the correct credentials
- **Check**: Make sure you're not overriding `PGPASSWORD` in environment variables

### **Issue: "Database does not exist"**
- **Solution**: The database is created automatically by Railway
- **Check**: Wait for database initialization to complete

## 📊 **Expected Logs**

When the application starts successfully, you should see:

```
🔌 Database connection details:
   Host: postgres.railway.internal
   Port: 5432
   Database: railway
   User: postgres
🔌 Connecting to database: postgres.railway.internal:5432/railway
📋 Database tables created/verified
✅ Database connected successfully
🚀 Starting Flask app on port 8080
```

## 🔗 **Test Your API**

Once deployed, test your API:

```bash
# Health check
curl https://your-app-name.railway.app/

# Register user
curl -X POST https://your-app-name.railway.app/auth/register \
  -H "Content-Type: application/json" \
  -d '{"email":"test@example.com","username":"testuser","password":"password123"}'
```

## 📝 **Notes**

- Railway automatically provides PostgreSQL environment variables
- The application is configured to use Railway's standard PostgreSQL variable names
- Database tables are created automatically on first run
- Connection pooling is enabled for better performance 