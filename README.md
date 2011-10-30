# OmniAuth.org

This is the source code for [omniauth.org](http://www.omniauth.org), the
simple landing site for the [OmniAuth](https://github.com/intridea/omniauth)
authentication framework for Ruby. It serves as a central starting point
for those who are interested in OmniAuth.

## Try OmniAuth

One of the neatest features of the site is that it gives users the
ability to quickly try out the various OmniAuth strategies for
themselves. The goal of the site is to have as many strategies as
possible represented in the "Try OmniAuth" section.

### Adding a Strategy

If you are a strategy author and would like to have your strategy
included, please follow these steps:

1. Fork the repository, adding the needed gem to the Gemfile
2. Add the provider in `application.rb` with whatever configuration it
   needs. If there is an application key and/or secret, you should use
   environment variables named `MYPROVIDER_KEY` and `MYPROVIDER_SECRET`
   (see existing strategies for details.
3. Open the `providers.yml` file and add yours to it. Make sure that the
   top-level key is the same as the URL (`/auth/:yourprovider`).
4. Open a pull request to bring your new strategy into the main repo!
5. If you need Heroku environment variables set, set up callback URLs to
   point to `http://www.omniauth.org/auth/:yourprovider/callback` and
   [send a message](https://github.com/inbox/new/mbleigh) with the
   config variables you need set. I will add them before I push to Heroku.

## License

Copyright (c) 2011 Michael Bleigh and Intridea, Inc.

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
