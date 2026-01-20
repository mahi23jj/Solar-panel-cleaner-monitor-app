import 'package:flutter/material.dart';
import 'package:ietp_project/starter/model/cleaning_status.dart';
import 'package:ietp_project/starter/providers/arduino_provider.dart';
import 'package:provider/provider.dart';

class CleaningScreen extends StatelessWidget {
  const CleaningScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ArduinoProvider>(
      builder: (_, vm, __) {
        final status = vm.currentData!.cleaningStatus;

        return Scaffold(
          backgroundColor: Colors.white,
          body: SafeArea(
            child: Column(
              children: [
                _Header(status: status),
                const SizedBox(height: 8),
                Expanded(child: _MainCard(status: status)),
                _Controls(status: status),
              ],
            ),
          ),
        );
      },
    );
  }
}

// ---------------- HEADER ----------------
class _Header extends StatelessWidget {
  final CleaningStatus status;
  const _Header({required this.status});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              IconButton(
                onPressed: () => Navigator.pop(context),
                icon: Icon(Icons.arrow_back_ios_new, color: Colors.grey[700]),
              ),
              const SizedBox(width: 8),
              Text(
                "Solar Panel Cleaning",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey[900],
                ),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: status.isCleaning
                      ? const Color(0xFFE8F5E9)
                      : Colors.grey[100],
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: status.isCleaning
                            ? const Color(0xFF4CAF50)
                            : Colors.grey[500],
                      ),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      status.isCleaning ? "ACTIVE" : "IDLE",
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: status.isCleaning
                            ? const Color(0xFF4CAF50)
                            : Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _PhaseInfo(status: status),
          if (status.maxCycles > 0) ...[
            const SizedBox(height: 20),
            _ProgressBar(status: status),
          ],
        ],
      ),
    );
  }
}

// ---------------- PHASE INFO ----------------
class _PhaseInfo extends StatelessWidget {
  final CleaningStatus status;
  const _PhaseInfo({required this.status});

  Color get _color => _phaseColor(status.phase);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: _color.withOpacity(0.08),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: _color.withOpacity(0.2)),
          ),
          child: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: _color.withOpacity(0.15),
                  shape: BoxShape.circle,
                ),
                child: Icon(_phaseIcon(status.phase), color: _color, size: 20),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _phaseText(status.phase),
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey[900],
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _phaseDescription(status.phase),
                      style: TextStyle(fontSize: 13, color: Colors.grey[600]),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// ---------------- PROGRESS BAR ----------------
class _ProgressBar extends StatelessWidget {
  final CleaningStatus status;
  const _ProgressBar({required this.status});

  Color get _color => _phaseColor(status.phase);

  @override
  Widget build(BuildContext context) {
    final progress = status.maxCycles > 0
        ? status.currentCycle / status.maxCycles
        : 0.0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Cleaning Progress",
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Colors.grey[700],
              ),
            ),
            Text(
              status.maxCycles > 0
                  ? "${status.currentCycle}/${status.maxCycles} cycles"
                  : "No cycles set",
              style: TextStyle(fontSize: 13, color: Colors.grey[600]),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Stack(
          children: [
            Container(
              height: 8,
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(4),
              ),
            ),
            Container(
              height: 8,
              width: MediaQuery.of(context).size.width * progress,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [_color, _color.withOpacity(0.7)],
                ),
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Text(
              "${(progress * 100).toStringAsFixed(0)}%",
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: _color,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

// ---------------- MAIN CARD ----------------
class _MainCard extends StatelessWidget {
  final CleaningStatus status;
  const _MainCard({required this.status});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 20,
            spreadRadius: 2,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(color: Colors.grey.withOpacity(0.1)),
      ),
      child: Column(
        children: [
          Expanded(
            child: Container(
              margin: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                image: DecorationImage(
                  image: AssetImage(_phaseImage(status.phase)),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.grey[50],
              borderRadius: const BorderRadius.vertical(
                bottom: Radius.circular(20),
              ),
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _StatCard(
                      icon: Icons.cyclone,
                      label: "Current Phase",
                      value: _phaseText(status.phase),
                      color: _phaseColor(status.phase),
                    ),
                    _StatCard(
                      icon: Icons.repeat,
                      label: "Cycle",
                      value: status.maxCycles > 0
                          ? "${status.currentCycle}/${status.maxCycles}"
                          : "N/A",
                      color: const Color(0xFF7E57C2), // Light purple
                    ),
                    _StatCard(
                      icon: Icons.list,
                      label: "Phase",
                      value: "${status.phase.index + 1}/8",
                      color: const Color(0xFF5C6BC0), // Another purple shade
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                _PhaseTimeline(currentPhase: status.phase),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ---------------- STAT CARD ----------------
class _StatCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color color;

  const _StatCard({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: color, size: 20),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: TextStyle(
            fontSize: 11,
            color: Colors.grey[600],
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            fontSize: 13,
            color: Colors.grey[900],
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}

// ---------------- PHASE TIMELINE ----------------
class _PhaseTimeline extends StatelessWidget {
  final CleaningPhase currentPhase;
  const _PhaseTimeline({required this.currentPhase});

  @override
  Widget build(BuildContext context) {
    final phases = CleaningPhase.values;
    final activeColor = _phaseColor(currentPhase);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Cleaning Phases",
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Colors.grey[700],
          ),
        ),
        const SizedBox(height: 16),
        Stack(
          children: [
            // Background line
            /*   Container(
              height: 3,
              margin: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ), */
            // Progress line
            Container(
              height: 3,
              width:
                  (currentPhase.index / (phases.length - 1)) *
                  (MediaQuery.of(context).size.width - 48),
              decoration: BoxDecoration(
                color: activeColor,
                borderRadius: BorderRadius.circular(2),
              ),
            ),

            // Dots
            /*  Row(
              // mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: phases.map((phase) {
                final index = phase.index;
                final isActive = index <= currentPhase.index;
                final isCurrent = index == currentPhase.index;

                return Column(
                  children: [
                    Container(
                      width: 18,
                      height: 18,
                      decoration: BoxDecoration(
                        color: isActive ? activeColor : Colors.white,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: isActive ? activeColor : Colors.grey[400]!,
                          width: isCurrent ? 2 : 1,
                        ),
                        boxShadow: isCurrent
                            ? [
                                BoxShadow(
                                  color: activeColor.withOpacity(0.3),
                                  blurRadius: 8,
                                  spreadRadius: 2,
                                ),
                              ]
                            : null,
                      ),
                      child: isActive
                          ? Center(
                              child: Icon(
                                Icons.check,
                                size: 12,
                                color: isCurrent ? activeColor : Colors.white,
                              ),
                            )
                          : null,
                    ),
                    const SizedBox(height: 8),
                    SizedBox(
                      width: 40,
                      child: Text(
                        _shortPhaseName(phase),
                        textAlign: TextAlign.center,
                        maxLines: 2,
                        style: TextStyle(
                          fontSize: 9,
                          color: isActive ? activeColor : Colors.grey[600],
                          fontWeight: isCurrent ? FontWeight.w600 : FontWeight.w400,
                        ),
                      ),
                    ),
                  ],
                );
              }).toList(),
            ), */
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: phases.map((phase) {
                final index = phase.index;
                final isActive = index <= currentPhase.index;
                final isCurrent = index == currentPhase.index;

                return Expanded(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // DOT
                      Container(
                        width: 18,
                        height: 18,
                        decoration: BoxDecoration(
                          color: isActive ? activeColor : Colors.white,
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: isActive ? activeColor : Colors.grey[400]!,
                            width: isCurrent ? 2 : 1,
                          ),
                          boxShadow: isCurrent
                              ? [
                                  BoxShadow(
                                    color: activeColor.withOpacity(0.3),
                                    blurRadius: 8,
                                    spreadRadius: 2,
                                  ),
                                ]
                              : null,
                        ),
                        child: isActive
                            ? Icon(
                                Icons.check,
                                size: 12,
                                color: isCurrent ? activeColor : Colors.white,
                              )
                            : null,
                      ),

                      const SizedBox(height: 6),

                      // LABEL
                      SizedBox(
                        height: 28, // 👈 FIXED HEIGHT prevents jumping
                        child: Text(
                          _shortPhaseName(phase),
                          textAlign: TextAlign.center,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 9,
                            color: isActive ? activeColor : Colors.grey[600],
                            fontWeight: isCurrent
                                ? FontWeight.w600
                                : FontWeight.w400,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      ],
    );
  }
}

// ---------------- CONTROLS ----------------
class _Controls extends StatelessWidget {
  final CleaningStatus status;
  const _Controls({required this.status});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 15,
            spreadRadius: 2,
            offset: const Offset(0, -2),
          ),
        ],
        border: Border.all(color: Colors.grey.withOpacity(0.1)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _ActionButton(
            isActive: status.isCleaning,
            label: status.isCleaning ? "PAUSE" : "START",
            icon: status.isCleaning ? Icons.pause : Icons.play_arrow,
            color: const Color(0xFF7E57C2), // Light purple
          ),
          _SmallButton(icon: Icons.stop, label: "STOP", color: Colors.red),
          _SmallButton(
            icon: Icons.refresh,
            label: "RESET",
            color: Colors.orange,
          ),
        ],
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  final bool isActive;
  final String label;
  final IconData icon;
  final Color color;

  const _ActionButton({
    required this.isActive,
    required this.label,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        height: 50,
        margin: const EdgeInsets.symmetric(horizontal: 4),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [color, Color.lerp(color, Colors.white, 0.2)!],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.3),
              blurRadius: 8,
              spreadRadius: 1,
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: Colors.white, size: 20),
            const SizedBox(width: 8),
            Text(
              label,
              style: const TextStyle(
                fontSize: 14,
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SmallButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;

  const _SmallButton({
    required this.icon,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        height: 50,
        margin: const EdgeInsets.symmetric(horizontal: 4),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.withOpacity(0.2)),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: color, size: 20),
            const SizedBox(height: 2),
            Text(
              label,
              style: TextStyle(
                fontSize: 11,
                color: color,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ---------------- HELPER FUNCTIONS ----------------
String _shortPhaseName(CleaningPhase phase) {
  switch (phase) {
    case CleaningPhase.dustDetected:
      return "Dust";
    case CleaningPhase.sprayingWater:
      return "Spray";
    case CleaningPhase.aggressiveCleaning:
      return "Clean";
    case CleaningPhase.cleaningCycle:
      return "Cycle";
    case CleaningPhase.returningToHome:
      return "Home";
    case CleaningPhase.waitingBeforeResume:
      return "Wait";
    case CleaningPhase.cleaningComplete:
      return "Done";
    case CleaningPhase.stopped:
      return "Stopped";
    case CleaningPhase.error:
      return "Error";
    case CleaningPhase.idle:
    default:
      return "Ready";
  }
}

String _phaseText(CleaningPhase phase) {
  switch (phase) {
    case CleaningPhase.dustDetected:
      return "Dust Detected";
    case CleaningPhase.sprayingWater:
      return "Spraying Water";
    case CleaningPhase.aggressiveCleaning:
      return "Cleaning in Progress";
    case CleaningPhase.cleaningCycle:
      return "Executing Cleaning Cycle";
    case CleaningPhase.returningToHome:
      return "Returning to Home Position";
    case CleaningPhase.waitingBeforeResume:
      return "Waiting Before Resume";
    case CleaningPhase.cleaningComplete:
      return "Cleaning Complete";
    case CleaningPhase.stopped:
      return "Cleaning Stopped";
    case CleaningPhase.error:
      return "System Error";
    case CleaningPhase.idle:
    default:
      return "System Ready";
  }
}

String _phaseDescription(CleaningPhase phase) {
  switch (phase) {
    case CleaningPhase.dustDetected:
      return "Dust level exceeded the safe threshold.";

    case CleaningPhase.sprayingWater:
      return "Water pump is active to loosen dust on the solar panels.";

    case CleaningPhase.aggressiveCleaning:
      return "Servo motor is performing aggressive sweeping motions.";

    case CleaningPhase.cleaningCycle:
      return "A cleaning cycle is currently being executed.";

    case CleaningPhase.returningToHome:
      return "Cleaning arm is returning to its default position.";

    case CleaningPhase.waitingBeforeResume:
      return "System is waiting before resuming dust monitoring.";

    case CleaningPhase.cleaningComplete:
      return "All cleaning cycles completed successfully.";

    case CleaningPhase.stopped:
      return "Cleaning process was manually stopped.";

    case CleaningPhase.error:
      return "An error occurred in the system or communication.";

    case CleaningPhase.idle:
    default:
      return "System is idle and monitoring dust levels.";
  }
}

IconData _phaseIcon(CleaningPhase phase) {
  switch (phase) {
    case CleaningPhase.dustDetected:
      return Icons.warning_amber_rounded; // Dust alert

    case CleaningPhase.sprayingWater:
      return Icons.water_drop_rounded; // Water spraying

    case CleaningPhase.aggressiveCleaning:
      return Icons.cleaning_services_rounded; // Active cleaning

    case CleaningPhase.cleaningCycle:
      return Icons.sync_rounded; // Repeating cycles

    case CleaningPhase.returningToHome:
      return Icons.home_rounded; // Returning to default position

    case CleaningPhase.waitingBeforeResume:
      return Icons.hourglass_bottom_rounded; // Waiting delay

    case CleaningPhase.cleaningComplete:
      return Icons.check_circle_rounded; // Success

    case CleaningPhase.stopped:
      return Icons.stop_circle_rounded; // Manual stop

    case CleaningPhase.error:
      return Icons.error_rounded; // Error state

    case CleaningPhase.idle:
    default:
      return Icons.power_settings_new_rounded; // System ready
  }
}


String _phaseImage(CleaningPhase phase) {
  switch (phase) {
    case CleaningPhase.sprayingWater:
      return 'assets/images/spray.jpg';
    case CleaningPhase.aggressiveCleaning:
      return 'assets/images/action.jpg';
    case CleaningPhase.cleaningCycle:
      return 'assets/images/action.jpg';
    case CleaningPhase.returningToHome:
      return 'assets/images/action.jpg';
    case CleaningPhase.waitingBeforeResume:
      return 'assets/images/action.jpg';
    case CleaningPhase.cleaningComplete:
      return 'assets/images/clean.jpg';
    case CleaningPhase.stopped:
      return 'assets/images/clean.jpg';
    default:
      return 'assets/images/dirty.jpg';
  }
}

Color _phaseColor(CleaningPhase phase) {
  switch (phase) {
    case CleaningPhase.dustDetected:
      return const Color(0xFFFF5722); // Deep orange
    case CleaningPhase.sprayingWater:
      return const Color(0xFF2196F3); // Blue
    case CleaningPhase.aggressiveCleaning:
      return const Color(0xFF2196F3); // Blue

    case CleaningPhase.cleaningCycle:
      return const Color(0xFF2196F3); // Blue
    case CleaningPhase.returningToHome:
      return const Color(0xFF2196F3); // Blue
    case CleaningPhase.waitingBeforeResume:
      return const Color(0xFFFFC107); // Amber

    // return const Color(0xFFFFC107); // Amber
    case CleaningPhase.cleaningComplete:
      return const Color(0xFF00BCD4); // Cyan
    case CleaningPhase.stopped:
      return const Color(0xFFF44336); // Red
    default:
      return const Color(0xFF7E57C2); // Light purple (changed from grey)
  }
}
