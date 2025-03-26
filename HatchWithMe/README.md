# Hatch With Me

A SwiftUI app for managing bird egg hatching.

## Project Structure

```
HatchWithMe/
├── Views/
│   ├── Components/          # Reusable UI components
│   │   ├── ActionButtons.swift
│   │   ├── ActiveHatchesSection.swift
│   │   ├── BannerAdView.swift
│   │   ├── DayView.swift
│   │   ├── EggCountBadge.swift
│   │   ├── HatchRow.swift
│   │   └── WelcomeCard.swift
│   ├── Features/           # Main feature views
│   │   ├── AddHatchView.swift
│   │   ├── CalendarView.swift
│   │   ├── ChatView.swift
│   │   ├── EditHatchView.swift
│   │   ├── HatchDetailView.swift
│   │   ├── HatchNotesView.swift
│   │   ├── HatchView.swift
│   │   └── PurchaseView.swift
│   └── Legal/             # Legal-related views
│       └── LegalView.swift
├── Models/
│   ├── Services/          # Business logic and services
│   │   └── AIAssistantService.swift
│   ├── Managers/          # State and feature managers
│   │   ├── AdManager.swift
│   │   ├── StoreKitManager.swift
│   │   └── SubscriptionManager.swift
│   └── Entities/          # Data models
│       ├── BirdType.swift
│       ├── Hatch.swift
│       └── HatchEntity.swift
├── Data/
│   ├── Store/            # Data persistence
│   │   ├── HatchModel.xcdatamodeld
│   │   └── PersistenceController.swift
│   └── Config/           # Configuration files
│       ├── Config.swift
│       ├── Configuration.swift
│       └── Configuration.storekit
└── Resources/            # Assets and resources
    ├── Assets.xcassets/
    └── Preview Content/
```

## Key Files

- `HatchWithMeApp.swift`: Main app entry point
- `HatchViewModel.swift`: Main view model for hatch management
- `Info.plist`: App configuration and permissions

## Features

- Egg hatching management
- AI Assistant for guidance
- Ad removal option
- Subscription-based premium features
- Calendar view for tracking
- Detailed hatch information
- Notes and documentation

## Dependencies

- SwiftUI
- CoreData
- StoreKit
- Google AdMob 