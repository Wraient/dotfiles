const express = require('express');
const router = express.Router();
const Blog = require('../models/blog');

router.get('/', async (req, res) => {
  const blogs = await Blog.find({});
  res.render('blogs', { blogs });
});

router.get('/:id', async (req, res) => {
  const blog = await Blog.findById(req.params.id);
  res.render('blog', { blog });
});

router.post('/new', async (req, res) => {
  const { title, content } = req.body;
  const newBlog = new Blog({ title, content });
  await newBlog.save();
  res.redirect('/blogs');
});

module.exports = router;
