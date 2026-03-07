import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class EsewaPaymentPage extends StatefulWidget {
  final String paymentUrl;
  final Map<String, dynamic> formData;

  const EsewaPaymentPage({
    super.key,
    required this.paymentUrl,
    required this.formData,
  });

  @override
  State<EsewaPaymentPage> createState() => _EsewaPaymentPageState();
}

class _EsewaPaymentPageState extends State<EsewaPaymentPage> {
  late final WebViewController _controller;
  bool _isLoading = true;

  String _buildAutoSubmitHtml() {
    final hiddenInputs = widget.formData.entries.map((entry) {
      return '<input type="hidden" name="${entry.key}" value="${entry.value}">';
    }).join();

    return '''
    <html>
      <body onload="document.forms[0].submit();">
        <form method="POST" action="${widget.paymentUrl}">
          $hiddenInputs
        </form>
        <div style="display:flex;justify-content:center;align-items:center;height:100vh;">
          Redirecting to eSewa...
        </div>
      </body>
    </html>
    ''';
  }

  bool _isSuccessUrl(String url) {
    return url.contains('/api/payments/esewa/success');
  }

  bool _isFailureUrl(String url) {
    return url.contains('/api/payments/esewa/failure');
  }

  @override
  void initState() {
    super.initState();

    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (_) {
            if (mounted) setState(() => _isLoading = true);
          },
          onPageFinished: (_) {
            if (mounted) setState(() => _isLoading = false);
          },
          onNavigationRequest: (request) {
            final url = request.url;

            if (_isSuccessUrl(url)) {
              Navigator.pop(context, true);
              return NavigationDecision.prevent;
            }

            if (_isFailureUrl(url)) {
              Navigator.pop(context, false);
              return NavigationDecision.prevent;
            }

            return NavigationDecision.navigate;
          },
        ),
      )
      ..loadHtmlString(_buildAutoSubmitHtml());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('eSewa Payment'),
      ),
      body: Stack(
        children: [
          WebViewWidget(controller: _controller),
          if (_isLoading)
            const Center(child: CircularProgressIndicator()),
        ],
      ),
    );
  }
}