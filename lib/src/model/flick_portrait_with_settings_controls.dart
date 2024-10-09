import 'package:flutter/material.dart';
import 'package:flick_video_player/flick_video_player.dart';
import 'package:vimeo_video_player/src/model/vimeo_video_config.dart';

class FlickPortraitWithSettingsControls extends StatelessWidget {
  final FlickManager flickManager;
  final ValueNotifier<bool> isSettingsButtonVisible;
  final ValueNotifier<List<VimeoVideoFile>> files;
  final Function(String) onUpdate;

  const FlickPortraitWithSettingsControls({
    Key? key,
    required this.flickManager,
    required this.isSettingsButtonVisible,
    required this.files,
    required this.onUpdate,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        const FlickPortraitControls(), // Default controls

        // Use ValueListenableBuilder to show/hide settings button dynamically with animation
        ValueListenableBuilder<bool>(
          valueListenable: isSettingsButtonVisible,
          builder: (context, isVisible, child) {
            return Positioned(
              right: 10,
              top: 10,
              child: AnimatedOpacity(
                opacity: isVisible ? 1.0 : 0.0, // Show or hide with opacity
                duration:
                    const Duration(milliseconds: 300), // Animation duration
                curve: Curves.easeInOut, // Smooth animation curve
                child: isVisible
                    ? IconButton(
                        icon: const Icon(Icons.settings, color: Colors.white),
                        onPressed: () {
                          _showSettings(context);
                        },
                      )
                    : const SizedBox
                        .shrink(), // Hide the button when isVisible is false
              ),
            );
          },
        ),
      ],
    );
  }

  void _showSettings(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext context) {
        return Container(
          color: Colors.white,
          padding: const EdgeInsets.all(16.0), // Add padding for better spacing
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.high_quality),
                title: const Text('Video Quality'),
                onTap: () {
                  Navigator.pop(context); // Close the current BottomSheet
                  _showQualityOptions(
                      context); // Show the nested quality options
                },
              ),
              // ListTile(
              //   leading: const Icon(Icons.speed),
              //   title: const Text('Playback Speed'),
              //   onTap: () {
              //     // Handle playback speed change
              //     Navigator.pop(context);
              //   },
              // ),
            ],
          ),
        );
      },
    );
  }

  // Method to show video quality options based on available files
  void _showQualityOptions(BuildContext context) {
  // Retrieve the video files
  List<VimeoVideoFile> videoFiles = files.value;

  // Sort the video files from max to min based on their quality
  videoFiles.sort((a, b) {
    int qualityA = int.parse(a.publicName!.replaceAll('p', ''));
    int qualityB = int.parse(b.publicName!.replaceAll('p', ''));
    return qualityB.compareTo(qualityA); // Sort in descending order
  });

  // Use a Set to remove duplicate video files based on their publicName
  Set<String> displayedNames = {}; // Set to track displayed file names

  showModalBottomSheet(
    context: context,
    builder: (BuildContext context) {
      return Container(
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: videoFiles.where((file) {
              // Only keep files with unique public names
              return displayedNames.add(file.publicName!);
            }).map((file) {
              return ListTile(
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(file.publicName!), // Display the publicName
                    if (flickManager.flickVideoManager!.videoPlayerController!.dataSource == file.link)
                      Icon(Icons.check), // Display a check icon if selected
                  ],
                ),
                onTap: () {
                  _changeVideoQuality(file.link!); // Change the video quality
                  Navigator.pop(context); // Close the BottomSheet
                },
              );
            }).toList(),
          ),
        ),
      );
    },
  );
}
// Method to handle video quality change
  void _changeVideoQuality(String link) {
    onUpdate(link);
  }
}
