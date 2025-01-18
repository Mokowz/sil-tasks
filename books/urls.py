from django.urls import path
from .views import (
  BookList,
  BookDetail,
  AuthorList,
  AuthorDetail
)


urlpatterns = [
  path('', BookList.as_view()),
  path('books/<int:id>/', BookDetail.as_view()),
  path('authors/', AuthorList.as_view()),
  path('authors/<int:id>/', AuthorDetail.as_view())
]