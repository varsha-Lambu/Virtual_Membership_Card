import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

void main() {
  runApp(const VirtualMembershipApp());
}

class VirtualMembershipApp extends StatelessWidget {
  const VirtualMembershipApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Virtual Membership Card',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: const Color(0xFFF5F7FA),
      ),
      home: const MembershipCardScreen(
        userName: 'JohnDoe123',
        membershipType: 'platinum',
        userId: 'ID:XF-7890-2023',
      ),
    );
  }
}

class MembershipCardScreen extends StatefulWidget {
  final String userName;
  final String membershipType;
  final String userId;

  const MembershipCardScreen({
    super.key,
    required this.userName,
    required this.membershipType,
    required this.userId,
  });

  @override
  State<MembershipCardScreen> createState() => _MembershipCardScreenState();
}

class _MembershipCardScreenState extends State<MembershipCardScreen> {
  late String _qrData;
  late DateTime _lastUpdated;
  bool _showUserId = false;
  bool _isHovering = false;

  @override
  void initState() {
    super.initState();
    _generateNewQRCode();
  }

  void _generateNewQRCode() {
    setState(() {
      _lastUpdated = DateTime.now();
      _qrData = '${widget.userName}|${widget.userId}|${_lastUpdated.millisecondsSinceEpoch}';
    });
  }

  Color _getMembershipColor() {
    switch (widget.membershipType.toLowerCase()) {
      case 'gold':
        return const Color(0xFFFFD700);
      case 'platinum':
        return const Color(0x80806BFF);
      default:
        return Colors.lightGreen;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'VIRTUAL MEMBERSHIP CARD',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            letterSpacing: 1.2,
          ),
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Membership Card
              Container(
                width: 350,
                height: 450,
                margin: const EdgeInsets.symmetric(vertical: 20),
                padding: const EdgeInsets.all(25),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.2),
                      spreadRadius: 3,
                      blurRadius: 15,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text(
                      widget.userName,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    // Interactive QR Area
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          _showUserId = !_showUserId;
                        });
                      },
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(25),
                            decoration: BoxDecoration(
                              color: _getMembershipColor(),
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: QrImageView(
                              data: _qrData,
                              size: 200,
                              backgroundColor: Colors.transparent,
                              eyeStyle: const QrEyeStyle(
                                eyeShape: QrEyeShape.square,
                                color: Colors.black,
                              ),
                              dataModuleStyle: const QrDataModuleStyle(
                                dataModuleShape: QrDataModuleShape.square,
                                color: Colors.black,
                              ),
                            ),
                          ),
                          Column(
                            children: [
                              const CircleAvatar(
                                radius: 30,
                                backgroundColor: Colors.white,
                                child: Icon(
                                  Icons.person,
                                  size: 30,
                                  color: Colors.black,
                                ),
                              ),
                              if (_showUserId)
                                Padding(
                                  padding: const EdgeInsets.only(top: 10),
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 12,
                                      vertical: 6,
                                    ),
                                    decoration: BoxDecoration(
                                      color: Colors.black.withOpacity(0.7),
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: Text(
                                      widget.userId,
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 14,
                                      ),
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 10,
                      ),
                      decoration: BoxDecoration(
                        color: _getMembershipColor(),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        '${widget.membershipType.toUpperCase()} MEMBER',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Hover-Aware Reset Button
              MouseRegion(
                onEnter: (_) => setState(() => _isHovering = true),
                onExit: (_) => setState(() => _isHovering = false),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  margin: const EdgeInsets.only(top: 20),
                  width: 220,
                  height: 55,
                  decoration: BoxDecoration(
                    color: _isHovering ? Colors.blueGrey.shade900 : Colors.blue.shade700,
                    borderRadius: BorderRadius.circular(30),
                    boxShadow: [
                      BoxShadow(
                        color: _isHovering
                            ? Colors.blue.shade800.withOpacity(0.5)
                            : Colors.blue.shade600.withOpacity(0.3),
                        blurRadius: _isHovering ? 10 : 5,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: TextButton(
                    onPressed: _generateNewQRCode,
                    style: TextButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    child: const Text(
                      'RESET QR CODE',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}