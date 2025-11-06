# Custom Message System

The Graviton app now includes a flexible custom message system that allows you to display various types of messages to users through Firebase Remote Config. This system supports rich messaging with different types, styling, action buttons, and expiry dates.

## Overview

The custom message system extends the existing notification infrastructure to provide more flexible messaging capabilities. Messages are controlled through Firebase Remote Config and can be displayed with appropriate icons, colors, and action buttons based on their type.

## Configuration Parameters

Configure the following parameters in Firebase Remote Config:

### Core Message Settings
- **`custom_message_enabled`** (boolean): Enable/disable custom messages globally
- **`custom_message_text`** (string): The message body text to display
- **`custom_message_type`** (string): Message type determining styling and icon
- **`custom_message_title`** (string): Optional custom title (defaults to type-based title)

### Action Button Settings
- **`custom_message_action_text`** (string): Text for action button (if provided, button will be shown)
- **`custom_message_action_url`** (string): URL to open when action button is pressed

### Behavior Settings
- **`custom_message_dismissible`** (boolean): Whether user can dismiss the message (default: true)
- **`custom_message_persistent`** (boolean): Whether message persists across app sessions (default: false)
- **`custom_message_expiry_date`** (string): ISO 8601 date string for message expiry (optional)

## Message Types

The system supports six message types, each with unique styling:

### `info` (Default)
- **Icon**: Information outline
- **Color**: Orange accent
- **Use case**: General information, tips, feature announcements

### `warning`
- **Icon**: Warning
- **Color**: Orange
- **Use case**: Important notices, deprecation warnings, cautions

### `success`
- **Icon**: Check circle
- **Color**: Green
- **Use case**: Successful operations, confirmations, achievements

### `announcement`
- **Icon**: Campaign
- **Color**: Primary purple
- **Use case**: Major announcements, news, updates

### `promotion`
- **Icon**: Local offer
- **Color**: Section purple
- **Use case**: Promotions, special offers, feature highlights

### `update`
- **Icon**: System update
- **Color**: Primary purple
- **Use case**: App updates, system notifications

## Priority System

Custom messages have the highest priority in the notification system:

1. **Custom Messages** (highest priority)
2. Maintenance Mode notifications
3. Standard notifications (lowest priority)

Only one notification type will be shown at a time, with custom messages taking precedence.

## Example Configurations

### Simple Information Message
```json
{
  "custom_message_enabled": true,
  "custom_message_type": "info",
  "custom_message_text": "New camera controls are now available! Explore 3D space with enhanced navigation.",
  "custom_message_dismissible": true
}
```

### Warning with Action Button
```json
{
  "custom_message_enabled": true,
  "custom_message_type": "warning",
  "custom_message_title": "Performance Notice",
  "custom_message_text": "For best performance, consider reducing trail length on older devices.",
  "custom_message_action_text": "Learn More",
  "custom_message_action_url": "https://graviton.app/performance-tips",
  "custom_message_dismissible": true
}
```

### Time-Limited Promotion
```json
{
  "custom_message_enabled": true,
  "custom_message_type": "promotion",
  "custom_message_text": "Special limited-time scenarios are now available! Explore new cosmic phenomena.",
  "custom_message_action_text": "Explore Now",
  "custom_message_action_url": "https://graviton.app/scenarios",
  "custom_message_expiry_date": "2024-12-31T23:59:59Z",
  "custom_message_dismissible": true
}
```

### Persistent App Update Notification
```json
{
  "custom_message_enabled": true,
  "custom_message_type": "update",
  "custom_message_text": "A new version with improved physics calculations is available.",
  "custom_message_action_text": "Update Now",
  "custom_message_action_url": "https://apps.apple.com/app/graviton/...",
  "custom_message_dismissible": false,
  "custom_message_persistent": true
}
```

## Implementation Details

### Code Structure

- **`CustomMessageType`**: Enum defining message types with display names and config values
- **`RemoteConfigService`**: Enhanced with custom message getters and priority logic
- **`MaintenanceDialog`**: Updated to support rich message display with type-specific styling
- **Default handling**: Graceful fallbacks for missing or invalid configuration

### Display Logic

1. Check if custom messages are enabled
2. Validate expiry date (if provided)
3. Determine message type and apply appropriate styling
4. Show dialog with type-specific icon and colors
5. Include action button if URL is provided
6. Handle dismiss behavior based on configuration

### Testing

Comprehensive test coverage includes:
- Message type parsing and validation
- Round-trip config value conversion
- Case-insensitive parsing
- Display name verification
- Default value handling

## Best Practices

### Message Content
- Keep messages concise and actionable
- Use clear, user-friendly language
- Include specific benefits or reasons for actions

### Timing
- Use expiry dates for time-sensitive messages
- Consider user time zones for global audiences
- Test message timing in development environment

### Action Buttons
- Provide clear, action-oriented button text
- Ensure URLs are accessible and relevant
- Test deep links thoroughly

### Dismissibility
- Make most messages dismissible for better UX
- Use non-dismissible messages sparingly (critical updates only)
- Consider persistent messages for important long-term notices

## Remote Config Testing

Use Firebase Remote Config's percentage rollouts and A/B testing features:

1. Start with small percentage rollouts (5-10%)
2. Monitor user engagement and feedback
3. Gradually increase rollout based on results
4. Use A/B testing for message effectiveness

## Troubleshooting

### Message Not Appearing
- Verify `custom_message_enabled` is `true`
- Check expiry date hasn't passed
- Ensure no higher priority notifications are active
- Verify Firebase Remote Config is fetching properly

### Styling Issues
- Confirm message type is valid (`info`, `warning`, `success`, `announcement`, `promotion`, `update`)
- Check for typos in configuration
- Invalid types default to `info` styling

### Action Button Not Working
- Verify both `custom_message_action_text` and `custom_message_action_url` are provided
- Test URL accessibility
- Check URL format (must be valid URI)

This custom message system provides a powerful and flexible way to communicate with users while maintaining the app's clean design and user experience.