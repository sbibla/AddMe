import SwiftUI

struct LevelSelectionView: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var userData: UserDataViewModel
    @Binding var selectedLevel: Int
    @Binding var isPresented: Bool
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.black.opacity(0.9)
                    .ignoresSafeArea()
                
                VStack(spacing: 20) {
                    Text("Select Starting Level")
                        .font(.title)
                        .foregroundColor(.white)
                        .padding(.top)
                    
                    Text("Choose a level to start from")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                    
                    ScrollView {
                        LazyVGrid(columns: [
                            GridItem(.flexible()),
                            GridItem(.flexible()),
                            GridItem(.flexible())
                        ], spacing: 20) {
                            ForEach(1...userData.user.highestLevel, id: \.self) { level in
                                Button {
                                    selectedLevel = level
                                    logManager.shared.logMessage("User selected level: \(level)", .info)
                                    isPresented = false
                                } label: {
                                    Text("Level \(level)")
                                        .font(.title3)
                                        .fontWeight(.bold)
                                        .foregroundColor(.white)
                                        .frame(width: 100, height: 100)
                                        .background(level == selectedLevel ? Color.brandPrimary : Color.gray.opacity(0.3))
                                        .cornerRadius(15)
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 15)
                                                .stroke(level == selectedLevel ? Color.brandPrimary : Color.clear, lineWidth: 2)
                                        )
                                }
                            }
                        }
                        .padding()
                    }
                }
            }
            .navigationBarItems(trailing: Button("Cancel") {
                isPresented = false
            })
        }
    }
}

#Preview {
    LevelSelectionView(selectedLevel: .constant(1), isPresented: .constant(true))
        .environmentObject(UserDataViewModel())
} 