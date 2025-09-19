FROM node:18-alpine

WORKDIR /app

# Копируем package.json и устанавливаем зависимости
COPY package*.json ./
RUN npm ci --only=production

# Копируем исходный код
COPY . .

# Строим приложение
RUN npm run build

# Создаем пользователя для безопасности
RUN addgroup -g 1001 -S nodejs
RUN adduser -S tradingbot -u 1001

# Создаем директории для данных
RUN mkdir -p data/logs data/backtest data/history
RUN chown -R tradingbot:nodejs data/

USER tradingbot

EXPOSE 3000

CMD ["npm", "start"]