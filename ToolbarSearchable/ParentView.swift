//
//  ParentView.swift
//  ToolbarSearchable
//
//  Created by Matt on 1/12/2025.
//

import SwiftUI

struct ParentView: View {

    private static var initialListItems: [Animal] {
        Animal.all.filter { [1, 2, 3].contains($0.id) }
    }

    @State private var listItems: [Animal] = ParentView.initialListItems

    @State private var navigationPath: NavigationPath
    @State private var searchPlaceText: String = ""

    let allAnimals: [Animal] = Animal.all

    var searchResults: [Animal] {
        if searchPlaceText.isEmpty {
            return []
        } else {
            return allAnimals.filter {
                $0.name.localizedCaseInsensitiveContains(searchPlaceText)
            }
        }
    }

    init() {
        var path = NavigationPath()

        if let firstAnimalInList = ParentView.initialListItems.first {
            path.append(firstAnimalInList)
        }

        _navigationPath = State(initialValue: path)
    }

    var body: some View {
        NavigationStack(path: $navigationPath) {
            ListView(animals: $listItems)
                .navigationDestination(for: Animal.self) { animal in
                    DetailView(name: animal.name, image: animal.systemImage, color: animal.color)
                }
                .toolbar {
                    ToolbarItem(placement: .bottomBar) {
                        Button("Settings", systemImage: "switch.2") {
                            //
                        }
                    }
                    ToolbarSpacer(.flexible, placement: .bottomBar)
                    DefaultToolbarItem(kind: .search, placement: .bottomBar)
                }
                .searchable(text: $searchPlaceText, placement: .navigationBarDrawer(displayMode: .always), prompt: "Search Animals", suggestions: {

                    if searchPlaceText.isEmpty {

                        ForEach(allAnimals, id: \.id) { animal in
                            Label(animal.name, systemImage: animal.systemImage)
                                .foregroundStyle(animal.color, .primary)
                                .symbolRenderingMode(.multicolor)
                                .onTapGesture {
                                    if !listItems.contains(where: { $0.id == animal.id }) {
                                        listItems.append(animal)
                                        searchPlaceText = ""
                                    }
                                }
                        }

                    } else if !searchPlaceText.isEmpty {
                        ForEach(searchResults, id: \.id) { animal in
                            Label(animal.name, systemImage: animal.systemImage)
                                .foregroundStyle(animal.color, .primary)
                                .symbolRenderingMode(.multicolor)
                                .onTapGesture {
                                    if !listItems.contains(where: { $0.id == animal.id }) {
                                        listItems.append(animal)
                                        searchPlaceText = ""
                                    }
                                }
                        }
                    }
                })

        }
    }
}

// MARK: - ListView

struct ListView: View {
    @Binding var animals: [Animal]

    var body: some View {
        Group {
            if animals.isEmpty {
                ContentUnavailableView("No Animals", systemImage: "pawprint.fill", description: Text("Tap the search bar to add animals."))
            } else {
                List {
                    ForEach(animals, id: \.id) { animal in
                        NavigationLink(value: animal) {
                            Label(animal.name, systemImage: animal.systemImage)
                                .foregroundStyle(animal.color, .primary)
                                .symbolRenderingMode(.multicolor)
                        }
                        .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                            Button(role: .destructive) {
                                remove(animal)
                            } label: {
                                Label("Remove", systemImage: "trash")
                            }
                        }
                    }
                }
            }
        }
    }

    private func remove(_ animal: Animal) {
        if let index = animals.firstIndex(where: { $0.id == animal.id }) {
            animals.remove(at: index)
        }
    }
}

// MARK: - DetailView

struct DetailView: View {
    let name: String
    let image: String
    let color: Color

    var body: some View {
        ContentUnavailableView(name, systemImage: image)
            .background(color.gradient.opacity(0.35))
            .foregroundStyle(.primary)
            .symbolRenderingMode(.multicolor)
    }
}

// MARK: - Animal Model

struct Animal: Identifiable, Hashable {
    let id: Int
    let name: String
    let systemImage: String
    let color: Color
}

extension Animal {

    static let catalog: [String: Animal] = [
        "ladybug": Animal(id: 1, name: "Ladybug", systemImage: "ladybug.fill", color: .red),
        "lizard": Animal(id: 2, name: "Lizard", systemImage: "lizard.fill", color: .green),
        "bird": Animal(id: 3, name: "Bird", systemImage: "bird.fill", color: .purple),
        "cat": Animal(id: 4, name: "Cat", systemImage: "cat.fill", color: .orange),
        "ant": Animal(id: 5, name: "Ant", systemImage: "ant.fill", color: .black),
        "fish": Animal(id: 6, name: "Fish", systemImage: "fish.fill", color: .blue),
        "dog": Animal(id: 7, name: "Dog", systemImage: "dog.fill", color: .brown),
        "tortoise": Animal(id: 8, name: "Tortoise", systemImage: "tortoise.fill", color: .green),
        "hare": Animal(id: 9, name: "Hare", systemImage: "hare.fill", color: .gray)
    ]

    static var all: [Animal] { Array(catalog.values) }
}

#Preview {
    ParentView()
}
