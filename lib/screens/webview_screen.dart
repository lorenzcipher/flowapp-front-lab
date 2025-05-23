import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import '../viewmodels/bank_viewmodel.dart';
import 'home_screen.dart';

class WebViewScreen extends StatefulWidget {
  @override
  _WebViewScreenState createState() => _WebViewScreenState();
}

class _WebViewScreenState extends State<WebViewScreen> {
  late final WebViewController _controller;
  bool _isWebViewLoading = true;

  @override
  void initState() {
    super.initState();
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (url) {
            setState(() => _isWebViewLoading = true);
          },
          onPageFinished: (url) {
            setState(() => _isWebViewLoading = false);
          },
          onNavigationRequest: (NavigationRequest request) {
            if (request.url.startsWith('intent://')) {
              _handleIntentUrl(request.url);
              return NavigationDecision.prevent;
            }
            return NavigationDecision.navigate;
          },
        ),
      );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initializeWebView();
    });
  }

  Future<void> _handleIntentUrl(String url) async {
    try {
      final httpsUrl = url.replaceFirst('intent://', 'https://');
      final uri = Uri.parse(httpsUrl.split('#')[0]);

      if (await canLaunchUrl(uri)) {
        await launchUrl(
          uri,
          mode: LaunchMode.externalApplication,
        );
      } else {
        // Fallback to loading in WebView if app isn't installed
        if (mounted) {
          await _controller.loadRequest(uri);
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error handling URL: ${e.toString()}')),
        );
      }
    }
  }

  Future<void> _initializeWebView() async {
    final bankViewModel = Provider.of<BankViewModel>(context, listen: false);

    try {
      await bankViewModel.generateBankUrl();
      if (bankViewModel.bankUrl != null && mounted) {
        await _controller.loadRequest(Uri.parse(bankViewModel.bankUrl!));
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to load bank URL: ${e.toString()}')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final bankViewModel = Provider.of<BankViewModel>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text("Bank Registration"),
        actions: [
          IconButton(
            icon: Icon(Icons.close),
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => HomeScreen()),
              );
            },
          ),
        ],
      ),
      body: _buildBody(bankViewModel),
    );
  }

  Widget _buildBody(BankViewModel bankViewModel) {
    if (bankViewModel.isLoading) {
      return Center(child: CircularProgressIndicator());
    }

    if (bankViewModel.errorMessage != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Error: ${bankViewModel.errorMessage}"),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _initializeWebView,
              child: Text("Retry"),
            ),
          ],
        ),
      );
    }

    return Stack(
      children: [
        WebViewWidget(controller: _controller),
        if (_isWebViewLoading)
          Center(child: CircularProgressIndicator()),
      ],
    );
  }

  @override
  void dispose() {
    _controller.clearCache();
    super.dispose();
  }
}