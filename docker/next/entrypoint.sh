#!/bin/sh

if [ -f /app/package.json ]; then
    npm install
fi

npm run dev