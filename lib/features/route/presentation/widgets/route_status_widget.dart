import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/route_provider.dart';

class RouteStatusWidget extends StatelessWidget {
  const RouteStatusWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<RouteProvider>(
      builder: (context, routeProvider, child) {
        return Container(
          margin: const EdgeInsets.all(16),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: _getStatusColor(routeProvider.state).withOpacity(0.9),
            borderRadius: BorderRadius.circular(8),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 6,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (routeProvider.state == RouteState.loading ||
                  routeProvider.state == RouteState.calculating)
                const SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: Colors.white,
                  ),
                )
              else
                Icon(
                  _getStatusIcon(routeProvider.state),
                  color: Colors.white,
                  size: 16,
                ),
              const SizedBox(width: 8),
              Text(
                _getStatusText(routeProvider),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Color _getStatusColor(RouteState state) {
    switch (state) {
      case RouteState.idle:
        return Colors.grey;
      case RouteState.loading:
      case RouteState.calculating:
        return Colors.orange;
      case RouteState.success:
        return Colors.green;
      case RouteState.error:
        return Colors.red;
    }
  }

  IconData _getStatusIcon(RouteState state) {
    switch (state) {
      case RouteState.idle:
        return Icons.touch_app;
      case RouteState.loading:
      case RouteState.calculating:
        return Icons.hourglass_empty;
      case RouteState.success:
        return Icons.check_circle;
      case RouteState.error:
        return Icons.error;
    }
  }

  String _getStatusText(RouteProvider provider) {
    switch (provider.state) {
      case RouteState.idle:
        if (provider.origin == null) {
          return 'Tap to select origin';
        } else if (provider.destination == null) {
          return 'Tap to select destination';
        } else {
          return 'Route ready';
        }
      case RouteState.loading:
        return 'Loading location...';
      case RouteState.calculating:
        return 'Calculating route...';
      case RouteState.success:
        return 'Route calculated successfully';
      case RouteState.error:
        return provider.errorMessage.isNotEmpty
            ? 'Error: ${provider.errorMessage}'
            : 'An error occurred';
    }
  }
}
