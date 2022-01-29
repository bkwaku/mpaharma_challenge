categories = [
  {
      "code": "A00",
      "title": "Cholera",
  },
  {
      "code": "A01",
      "title": "Typhoid and paratyphoid fevers",
  },
  {
      "code": "A010",
      "title": "Typhoid fever",
  },
  {
      "code": "A011",
      "title": "Paratyphoid fever A",
  },
  {
      "code": "A012",
      "title": "Paratyphoid fever B",
  },
  {
      "code": "A013",
      "title": "Paratyphoid fever C",
  },
  {
      "code": "A014",
      "title": "Paratyphoid fever, unspecified",
  },
  {
      "code": "A022",
      "title": "Localized salmonella infections",
  },
  {
      "code": "A028",
      "title": "Other specified salmonella infections",
  },
  {
      "code": "A029",
      "title": "Salmonella infection, unspecified",
  },
  {
      "code": "A03",
      "title": "Shigellosis",
  }
]

categories.each do |category|
  Category.create!(category)
end

