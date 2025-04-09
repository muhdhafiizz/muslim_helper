import 'package:flutter/material.dart';
import 'package:hadith_reader/providers/search_provider.dart';
import 'package:hadith_reader/screen/hadith_detail_page.dart';
import 'package:hadith_reader/widgets/shimmer_loading_widget.dart';
import 'package:provider/provider.dart';

class SearchPageView extends StatelessWidget {
  const SearchPageView({super.key});

  @override
  Widget build(BuildContext context) {
    final searchProvider = Provider.of<SearchProvider>(context);

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: const Icon(Icons.arrow_back),
                  ),
                  const SizedBox(width: 10),
                  const Text(
                    "Search",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              TextField(
                controller: searchProvider.searchController,
                decoration: InputDecoration(
                  hintText: "Please type to start searching for Hadith",
                  prefixIcon: const Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Expanded(
                child: ListView.builder(
                  controller: searchProvider.scrollController,
                  itemCount: searchProvider.hasMore
                      ? searchProvider.filteredHadiths.length + 1
                      : searchProvider.filteredHadiths.length,
                  itemBuilder: (context, index) {
                    if (index == searchProvider.filteredHadiths.length) {
                      return searchProvider.hasMore
                          ? const SizedBox(
                              height: 100,
                              child: Padding(
                                padding: EdgeInsets.all(10.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    ShimmerLoadingWidget(
                                        width: 500, height: 10),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    ShimmerLoadingWidget(
                                        width: 500, height: 10),
                                    SizedBox(
                                      height: 7,
                                    ),
                                    ShimmerLoadingWidget(width: 140, height: 10),
                                  ],
                                ),
                              ),
                            )
                          : const SizedBox.shrink();
                    }
                    final hadith = searchProvider.filteredHadiths[index];
                    return InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                HadithDetailPage(hadith: hadith),
                          ),
                        );
                      },
                      child: ListTile(
                        title: Expanded(
                          child: Text(
                            hadith.hadithEnglish,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        subtitle: Text(
                          "Book: ${hadith.bookSlug}",
                          style: const TextStyle(color: Colors.green),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
