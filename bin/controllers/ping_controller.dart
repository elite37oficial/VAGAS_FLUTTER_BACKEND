import 'dart:io';

import 'package:linux_system_info/linux_system_info.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';

class PingController {
  Handler get handler {
    var router = Router();
    const String buildNumber = '0.0.10';

    router.get('/ping', (Request request) async {
      final now = DateTime.now();
      String result = '';

      if (Platform.isLinux) {
        //CPU
        Stream<double> cpuUsage = CpuInfo.getCpuUsagePercentage();
        double cpuUsageMoment = await cpuUsage.first;
        //MEMORY
        var totalMem = MemInfo().mem_total_mb;
        var freeMem = MemInfo().mem_free_mb;

        result =
            '$now - Version:$buildNumber CPU Usage:$cpuUsageMoment Memory Free:$freeMem/$totalMem';
      } else {
        result = '$now - Version:$buildNumber';
      }

      return Response.ok(result);
    });

    return router;
  }
}
