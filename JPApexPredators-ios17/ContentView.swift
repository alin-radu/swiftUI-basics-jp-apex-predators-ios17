import MapKit
import SwiftUI

struct ContentView: View {
    let predators = Predators()

    @State var searchTerm = ""
    @State var alphabetical = false
    @State var currentSelection = PredatorType.all

    var filteredDinos: [ApexPredator] {
        predators.filter(by: currentSelection)

        predators.sort(by: alphabetical)

        return predators.search(for: searchTerm)
    }

    var body: some View {
        // print("predators= \(predators.apexPredators)")

        return
            NavigationStack {
                List(filteredDinos) { predator in
                    NavigationLink {
                        PredatorDetail(
                            predator: predator,
                            position: .camera(MapCamera(centerCoordinate: predator.location, distance: 30000))
                        )
                    } label: {
                        ListItemLabelView(predator: predator)
                    }
                }
                .navigationTitle("Apex Predators")
                .searchable(text: $searchTerm)
                .autocorrectionDisabled()
                .animation(.default, value: searchTerm)
                .toolbar {
                    ToolBarItems(alphabetical: $alphabetical, currentSelection: $currentSelection)
                }
            }
            .preferredColorScheme(/*@START_MENU_TOKEN@*/ .dark/*@END_MENU_TOKEN@*/)
    }
}

#Preview {
    ContentView()
}

// PredatorView //

struct ListItemLabelView: View {
    var predator: ApexPredator

    var body: some View {
        HStack {
            // dinosaur image
            Image(predator.image)
                .resizable()
                .scaledToFit()
                .frame(width: 100, height: 100)
                .shadow(color: .white, radius: 1)

            VStack(alignment: .leading) {
                // name
                Text(predator.name)
                    .fontWeight(/*@START_MENU_TOKEN@*/ .bold/*@END_MENU_TOKEN@*/)

                // type
                Text(predator.type.rawValue.capitalized)
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .padding(.horizontal, 13)
                    .padding(.vertical, 5)
                    .background(predator.type.background)
                    .clipShape(.capsule)
            }
        }
    }
}

// ToolBarItems //

struct ToolBarItems: ToolbarContent {
    @Binding var alphabetical: Bool
    @Binding var currentSelection: PredatorType

    var body: some ToolbarContent {
        ToolbarItem(placement: .topBarLeading) {
            Button {
                withAnimation {
                    alphabetical.toggle()
                }
            } label: {
                Image(systemName: alphabetical ? "film" : "textformat")
                    .symbolEffect(.bounce, value: alphabetical)
            }
        }

        ToolbarItem(placement: .topBarTrailing) {
            Menu {
                Picker("Filter", selection: $currentSelection.animation()) {
                    ForEach(PredatorType.allCases) { type in
                        Label(type.rawValue.capitalized, systemImage: type.icon)
                    }
                }
            } label: {
                Image(systemName: "slider.horizontal.3")
            }
        }
    }
}
