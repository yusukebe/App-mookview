[![Build Status](https://travis-ci.org/yusukebe/App-mookview.png?branch=master)](https://travis-ci.org/yusukebe/App-mookview)
# NAME

App::mookview - View Markdown texts as a "Mook-Book"

# SYNOPSIS

    use App::mookview;

    my $mookview = App::mookview->new('text.md');
    my $app = $mookview->psgi_app();

# DESCRIPTION

App::mookview is Plack/PSGI application for viewing Markdown texts as a "Mookbook".

# LICENSE

Copyright (C) Yusuke Wada.

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

# AUTHOR

Yusuke Wada <yusuke@kamawada.com>
