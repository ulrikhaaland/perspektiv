import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:spotify/spotify.dart';
import 'package:webview_flutter/webview_flutter.dart';

class Spotify extends StatefulWidget {
  Spotify({Key key}) : super(key: key);

  @override
  _SpotifyState createState() => _SpotifyState();
}

class _SpotifyState extends State<Spotify> {
  @override
  void initState() {
    _spotify();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center (
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            RaisedButton(
              color: Colors.green,
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => WebViewSpotifyLogin(),
                    ));
              },
            )
          ],
        ),
      ),
    );
  }

  Future<void> _spotify() async {
    // var keyJson = await File('example/.apikeys').readAsString();
    // var keyMap = json.decode(keyJson);

    var credentials = SpotifyApiCredentials(
        "327b570a449e4688b60a51ac54a0a731", "c447606517cb4d2eafac14f93a884c60");
    var spotify = SpotifyApi(credentials);
    
  }
}

class WebViewSpotifyLogin extends StatefulWidget {
  WebViewSpotifyLogin({Key key}) : super(key: key);

  @override
  _WebViewSpotifyLoginState createState() => _WebViewSpotifyLoginState();
}

class _WebViewSpotifyLoginState extends State<WebViewSpotifyLogin> {
  final Completer<WebViewController> _controller =
      Completer<WebViewController>();
  @override
  Widget build(BuildContext context) {
   return SafeArea(
        child: Material(
        child: WebView(
          onPageFinished: (response) {
            print(response);

            
          },
          javascriptMode: JavascriptMode.unrestricted,
            onWebViewCreated: (WebViewController webViewController) {
              _controller.complete(webViewController);
            },
          initialUrl:
              "https://accounts.spotify.com/authorize?client_id=327b570a449e4688b60a51ac54a0a731&response_type=code&redirect_uri=https%3A%2F%2Fexample.com%2Fcallback&scope=user-read-private%20user-read-email&state=34fFs29kd09",
        ),
      ),
   );
  }
}
