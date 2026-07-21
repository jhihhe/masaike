import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = AppViewModel()

    var body: some View {
        NavigationSplitView {
            ImageListView(viewModel: viewModel)
                .frame(minWidth: 220)
        } detail: {
            VStack(spacing: 0) {
                ToolbarView(viewModel: viewModel)
                    .padding()
                Divider()
                if let selected = viewModel.selectedItem {
                    EditorView(item: selected, viewModel: viewModel)
                        .id(selected.id)
                } else {
                    EmptyStateView()
                }
            }
        }
        .navigationTitle("马赛克工具")
    }
}

struct EmptyStateView: View {
    var body: some View {
        VStack(spacing: 12) {
            Image(systemName: "photo.on.rectangle.angled")
                .font(.system(size: 48))
                .foregroundColor(.secondary)
            Text("拖入图片或点击导入开始")
                .font(.title3)
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}
