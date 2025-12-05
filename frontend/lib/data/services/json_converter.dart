class JsonConverter {
  static Map<String, dynamic> convertToNewFormat(Map<String, dynamic> json) {
    final converted = Map<String, dynamic>.from(json);
    
    if (converted.containsKey('image_url')) {
      converted['image_path'] = converted['image_url'];
      converted.remove('image_url');
    }
    
    if (converted.containsKey('icon_url')) {
      converted['icon_path'] = converted['icon_url'];
      converted.remove('icon_url');
    }
    
    if (converted.containsKey('class_id') == false && converted.containsKey('classId')) {
      converted['class_id'] = converted['classId'];
      converted.remove('classId');
    }
    
    if (converted.containsKey('race_id') == false && converted.containsKey('raceId')) {
      converted['race_id'] = converted['raceId'];
      converted.remove('raceId');
    }
    
    if (converted.containsKey('owner_id') == false && converted.containsKey('ownerId')) {
      converted['owner_id'] = converted['ownerId'];
      converted.remove('ownerId');
    }
    
    if (converted.containsKey('campaign_id') == false && converted.containsKey('campaignId')) {
      converted['campaign_id'] = converted['campaignId'];
      converted.remove('campaignId');
    }
    
    if (converted.containsKey('faction_id') == false && converted.containsKey('factionId')) {
      converted['faction_id'] = converted['factionId'];
      converted.remove('factionId');
    }
    
    if (converted.containsKey('weapon_id') == false && converted.containsKey('weaponId')) {
      converted['weapon_id'] = converted['weaponId'];
      converted.remove('weaponId');
    }
    
    if (converted.containsKey('armor_id') == false && converted.containsKey('armorId')) {
      converted['armor_id'] = converted['armorId'];
      converted.remove('armorId');
    }
    
    if (converted.containsKey('character_ids') == false && converted.containsKey('characters')) {
      final chars = converted['characters'];
      if (chars is List) {
        converted['character_ids'] = chars.map((e) => e is Map ? e['id'] : e).toList();
        converted.remove('characters');
      }
    }
    
    if (converted.containsKey('member_ids') == false && converted.containsKey('characters')) {
      final chars = converted['characters'];
      if (chars is List) {
        converted['member_ids'] = chars.map((e) => e is Map ? e['id'] : e).toList();
        converted.remove('characters');
      }
    }
    
    if (converted.containsKey('allowed_class_ids') == false && converted.containsKey('classes')) {
      final classes = converted['classes'];
      if (classes is List) {
        // Filter out strings and keep only integers or maps with id
        final classIds = <int>[];
        for (var e in classes) {
          if (e is int) {
            classIds.add(e);
          } else if (e is Map && e.containsKey('id') && e['id'] is int) {
            classIds.add(e['id'] as int);
          }
          // Skip strings - they will be handled in Spell.fromJson if needed
        }
        // Only set allowed_class_ids if we have valid IDs, otherwise leave classes for Spell to handle
        if (classIds.isNotEmpty) {
          converted['allowed_class_ids'] = classIds;
          converted.remove('classes');
        } else {
          // If all are strings, leave classes as is and let Spell.fromJson handle it
          // Don't remove 'classes' so Spell can see it
        }
      }
    }
    
    if (converted.containsKey('reward_ids') == false && converted.containsKey('rewards')) {
      final rewards = converted['rewards'];
      if (rewards is List) {
        converted['reward_ids'] = rewards.map((e) => e is Map ? e['id'] : e).toList();
        converted.remove('rewards');
      }
    }
    
    if (converted.containsKey('markers') && converted['markers'] is List) {
      final markers = converted['markers'] as List;
      converted['markers'] = markers.map((m) {
        if (m is Map) {
          final marker = Map<String, dynamic>.from(m);
          if (marker.containsKey('campaign_id') == false && marker.containsKey('campaignId')) {
            marker['campaign_id'] = marker['campaignId'];
            marker.remove('campaignId');
          }
          return marker;
        }
        return m;
      }).toList();
    }
    
    return converted;
  }
}


