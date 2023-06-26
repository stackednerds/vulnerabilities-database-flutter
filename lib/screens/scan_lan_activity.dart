import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:getwidget/components/list_tile/gf_list_tile.dart';
import 'package:network_info_plus/network_info_plus.dart';
import 'package:network_tools/network_tools.dart';

class LanScanning extends StatefulWidget {
  const LanScanning({Key? key}) : super(key: key);

  @override
  State<LanScanning> createState() => _LanScanningState();
}

class _LanScanningState extends State<LanScanning> {
  bool isScanButtonPressed = false;
  List<ActiveHost> discoveredHosts = [];

  Future<String?> getRouterIPAddress() async {
    setState(() {
      isScanButtonPressed = true;
    });

    final NetworkInfo networkInfo = NetworkInfo();
    final String? routerIP = await networkInfo.getWifiGatewayIP();
    // print('Router IP Address: $routerIP');

    return routerIP;
  }

  Future<void> scanLAN(String gatewayIP) async {
    String address = gatewayIP;
    final String subnet = address.substring(0, address.lastIndexOf('.'));
    final stream = HostScanner.getAllPingableDevices(subnet,
        firstHostId: 1, lastHostId: 254, timeoutInSeconds: 2);

    setState(() {
      discoveredHosts.clear();
    });

    await for (var host in stream) {
      setState(() {
        discoveredHosts.add(host);
      });
    }

    setState(() {
      isScanButtonPressed = false;
    });
    // print('Scan completed');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      appBar: AppBar(
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline),
            onPressed: () {
              const snackBar = SnackBar(
                content: Text(
                    'Scan and discover all devices connected to the same network you are currently in'),
                duration: Duration(seconds: 3),
              );
              ScaffoldMessenger.of(context).showSnackBar(snackBar);
            },
          ),
        ],
        leading: IconButton(
          onPressed: () {},
          icon: const Icon(Icons.short_text),
        ),
        toolbarHeight: 60.0,
        backgroundColor: const Color(0xFF121212),
        title: const Text("LAN Scan"),
      ),
      body: isScanButtonPressed
          ? const Center(
              child: SizedBox(
                width: 50.0,
                height: 50.0,
                child: CircularProgressIndicator(
                  color: Colors.white,
                ),
              ),
            )
          : discoveredHosts.isEmpty
              ? Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      FontAwesomeIcons.hubspot,
                      size: 150.0,
                      color: Colors.white38,
                    ),
                    const Center(
                      child: Text(
                        'LAN Scanning',
                        style: TextStyle(
                          fontSize: 30.0,
                          color: Colors.white38,
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 30.0,
                    ),
                    SizedBox(
                      width: 150.0,
                      child: ElevatedButton(
                        onPressed: () {
                          setState(() {
                            getRouterIPAddress().then((value) {
                              if (value != null && value != "0.0.0.0") {
                                scanLAN(value);
                              } else {
                                const snackBar = SnackBar(
                                  content: Text(
                                      'No Wi-Fi connection or unable to retrieve the gateway IP address'),
                                  duration: Duration(seconds: 2),
                                );
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(snackBar);
                                isScanButtonPressed = false;
                                // print('Gateway IP address not available.');
                              }
                            });
                          });
                        },
                        style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.all(Colors.white)),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            Text(
                              'Scan LAN',
                              style: TextStyle(
                                  color: Colors.black, fontSize: 17.0),
                            ),
                            SizedBox(
                              width: 7.0,
                            ),
                            Icon(
                              Icons.screen_search_desktop_outlined,
                              color: Colors.black,
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                )
              : ListView.builder(
                  itemCount: discoveredHosts.length,
                  itemBuilder: (context, index) {
                    final host = discoveredHosts[index];

                    return GFListTile(
                      margin: const EdgeInsets.symmetric(
                          vertical: 10.0, horizontal: 10.0),
                      listItemTextColor: Colors.white,
                      color: const Color(0xFF222222),
                      title: Text(
                        host.address,
                        style: const TextStyle(
                            color: Colors.white,
                            fontSize: 20.0,
                            fontWeight: FontWeight.bold),
                      ),
                      subTitle: Padding(
                        padding: const EdgeInsets.only(left: 8.0, top: 4.0),
                        child: Text(
                          'Host Identifier: ${host.hostId}',
                          style: const TextStyle(color: Colors.white70),
                        ),
                      ),
                      description: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          'TTL: ${host.pingData.response?.ttl} ms, time: ${host.responseTime?.inMilliseconds} ms',
                          style: const TextStyle(color: Colors.white70),
                        ),
                      ),
                      icon: const Icon(Icons.circle, color: Colors.green),
                      avatar: Image.asset('assets/responsive.png', height: 70, width: 70,),
                    );
                  },
                ),
    );
  }
}
