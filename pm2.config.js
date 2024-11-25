module.exports = {
  apps: [
    {
      name: "backend",
      script: "npm",
      args: "run start:dev", // Uses hot-reload command
      cwd: "./back",         // Backend directory
      watch: ["./back/src"], // Watch for changes in the source folder
      ignore_watch: ["node_modules", "dist"], // Ignore unnecessary folders
      env: {
        NODE_ENV: "development",
      },
    },
    {
      name: "frontend",
      script: "npm",
      args: "run dev", // Frontend hot-reload
      cwd: "./front",  // Frontend directory
      watch: false,    // Next.js handles its own hot reload
      env: {
        NODE_ENV: "development",
      },
    },
    {
      name: "database",
      script: "bash",
      args: "-c \"docker inspect local-postgres >/dev/null 2>&1 || docker run --name local-postgres -e POSTGRES_USER=postgres -e POSTGRES_PASSWORD=password -e POSTGRES_DB=mydatabase -p 5432:5432 -d postgres:13\"",
      autorestart: false,
    },
  ],
};