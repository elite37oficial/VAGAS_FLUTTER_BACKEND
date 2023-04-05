import 'dart:io';

import 'package:linux_system_info/linux_system_info.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';

class PingController {
  Handler get handler {
    var router = Router();

    router.get('/ping', (Request request) async {
      final now = DateTime.now();
      String result = '';

      if (Platform.isLinux) {
        //CPU
        var cpuUsage = CpuInfo.getCpuUsagePercentage();
        //MEMORY
        var totalMem = MemInfo().mem_free_mb;

        result = '$now CPU Usage:$cpuUsage Memory Free:$totalMem';
      } else {
        result = now.toString();
      }

      return Response.ok(result);
    });

    return router;
  }
}
