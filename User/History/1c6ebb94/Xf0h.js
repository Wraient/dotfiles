const express = require('express');
const path = require('path');
const bodyParser = require('body-parser');
const mongoose = require('mongoose');
const session = require('express-session');
const flash = require('connect-flash');

const app = express();

// Connect to MongoDB
mongoose.connect('mongodb://localhost/my-portfolio-blog', {
  useNewUrlParser: true,
  useUnifiedTopology: true,
});

// Set up EJS for templating
app.set('view engine', 'ejs');
app.set('views', path.join(__dirname, 'views'));

// Middleware
app.use(express.static(path.join(__dirname, 'public')));
app.use(bodyParser.urlencoded({ extended: false }));
app.use(session({
  secret: 'secret',
  resave: true,
  saveUninitialized: true,
}));
app.use(flash());

// Routes
const indexRouter = require('./routes/index');
const blogsRouter = require('./routes/blogs');
const usersRouter = require('./routes/users');

app.use('/', indexRouter);
app.use('/blogs', blogsRouter);
app.use('/users', usersRouter);

// Start the server
const PORT = process.env.PORT || 3000;
app.listen(PORT, () => {
  console.log(`Server running on http://localhost:${PORT}`);
});
