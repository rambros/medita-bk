// Complex picker - keep as custom action (1169 lines of custom implementation)
export 'show_picker_number_format_value.dart' show showPickerNumberFormatValue;

// MIGRATED & DELETED - Now in AudioUtils (/core/utils/media/audio_utils.dart):
// - check_device_audios.dart → AudioUtils.checkDeviceAudios()
// - get_instrument_sounds.dart → AudioUtils.getInstrumentSounds()
// - play_sound.dart → AudioUtils.playSound()
// - select_audio_file.dart → AudioUtils.selectAudioFile()
// - delete_invalid_device_audios.dart → AudioUtils.deleteInvalidDeviceAudios()
// - is_audio_downloaded.dart → AudioUtils.isAudioDownloaded()
// - clear_audio_cache.dart → AudioUtils.clearAudioCache()

// MIGRATED & DELETED - Now in UIUtils (/ui/core/utils/ui_utils.dart):
// - reorder_items.dart → UIUtils.reorderItems()
// - share_image_and_text.dart → UIUtils.shareImageAndText()

// MIGRATED & DELETED - Now in NotificationService (/core/services/notification_service.dart):
// - initialize_notification_plugin.dart → NotificationService.initialize()
// - show_notification.dart → NotificationService.showNotification()
// - schedule_alarm.dart → NotificationService.scheduleAlarm()
// - delete_alarm_notification.dart → NotificationService.deleteAlarm()
// - initialize_time_zone.dart → NotificationService.initializeTimeZone()

// DELETED - Migrated to services/utils:
// - app_store_review.dart → ReviewService (deleted earlier)
// - in_app_review.dart → ReviewService (deleted earlier)
// - init_audio_service.dart → Duplicate of /core/services/audio_service.dart (deleted)
// - get_favorites_meditations.dart → MeditationService
// - convert_json_to_event_list.dart → AgendaService
// - change_profile_pic.dart → UserService (migration script)
// - download_file.dart → NetworkUtils
// - has_internet_access.dart → NetworkUtils
// - get_version_app.dart → FileUtils
