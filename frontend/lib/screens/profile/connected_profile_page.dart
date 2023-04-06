// 연동프로필 확인하는 페이지
import 'package:flutter/material.dart';
import 'package:frontend/services/api_profiles.dart';
import 'package:frontend/widgets/common/is_empty_data.dart';
import 'package:frontend/widgets/common/simple_app_bar.dart';
import 'package:dio/dio.dart' as dio;

class ConnectedProfilePage extends StatefulWidget {
  final int? profileLinkSeq;
  const ConnectedProfilePage({super.key, this.profileLinkSeq});

  @override
  State<ConnectedProfilePage> createState() => _ConnectedProfilePageState();
}

class _ConnectedProfilePageState extends State<ConnectedProfilePage> {
  List<Map<String, dynamic>> data = [];

  @override
  void initState() {
    super.initState();
    getlink();
  }

  void getlink() async {
    try {
      dio.Response response =
          await ApiProfiles.searchLink(widget.profileLinkSeq!);
      if (response.statusCode == 200) {
        final List<Map<String, dynamic>> newData =
            List<Map<String, dynamic>>.from(response.data['data']);
        setState(() {
          data = newData;
          print('data$data');
        });
      }
    } catch (error) {
      print('error$error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: const SimpleAppBar(title: '연동된 프로필 조회'),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('현재 접속되어있는 프로필과\n연결된 계정목록입니다',
                  style: TextStyle(fontSize: 20.0, color: Colors.black54)),
              const SizedBox(height: 16.0),
              Expanded(
                child: data.isEmpty
                    ? const IsEmptyData(what: '연동된 프로필')
                    : ListView.builder(
                        itemCount: data.length,
                        itemBuilder: (context, index) {
                          final profile = data[index];
                          return Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(6),
                                color: Colors.white),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.all(10.0),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            children: [
                                              Text(
                                                profile['email'],
                                                style: const TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 16,
                                                ),
                                              ),
                                              const SizedBox(
                                                width: 5.0,
                                              ),
                                              Text(
                                                profile['name'],
                                                style: const TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 16,
                                                ),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(height: 4.0),
                                          Row(
                                            children: [
                                              const Icon(
                                                Icons.calendar_month_rounded,
                                              ),
                                              const SizedBox(width: 4.0),
                                              Text(
                                                profile['regDttm'],
                                                style: const TextStyle(
                                                  fontSize: 14,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
              ),
              const SizedBox(height: 16.0),
            ],
          ),
        ));
  }
}
