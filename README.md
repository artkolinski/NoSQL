# Technologie NoSQL

## Artur Koliński

Wybrany zbiór danych 2.1Gb - [National Statistics Postcode Lookup UK](http://geoportal.statistics.gov.uk/datasets/055c2d8135ca4297a85d624bb68aefdb_0.geojson)

| Nazwa | Wartosć    |
|-----------------------|------------|
| Procesor | i5-6600K CPU 4 x 3,7 GHz |
| RAM | 16 GB |
| Dysk | SSD |
| System operacyjny | Windows 10 64-bit |
| Wersje użytych baz danych | |
| Wersje bibliotek | |

# Zaliczenie:

## Zadanie GEO
[Zadanie GEO](https://artkolinski.github.io/NoSQL/) 

###Przedstawienie dancyh

Przykładowy rekord:
```
{
		"type": "Feature",
		"properties": {
			"objectid": 2103,
			"pcd": "AB1 7PQ",
			"cty": "S99999999",
			"laua": "S12000033",
			"ward": "S13002486"
		},
		"geometry": {
			"type": "Point",
			"coordinates": [-2.1398023836870412, 57.125206167592985]
		}
	}
```

## PostgreSQL

### Zadanie 1

Dane: [Hardware Recs](https://archive.org/download/stackexchange/hardwarerecs.stackexchange.com.7z)

Plik: Users.xml

#### Konwertujemy Users.xml do csv i otrzymujemy tabele :

#### users.csv 

|Id|Reputation|CreationDate|DisplayName|LastAccessDate|AboutMe|Views|UpVotes|DownVotes|ProfileImageUrl|Age|AccountId|
|---|----------------|------|------------|------------|------|--------|--------|--------|--------|--------|--------|

<h6>Połączenie z postgresem</h6>
```psql -U postgres -h localhost```

<h6>Uruchomienie mierzenia czasu</h6>
```\timing```

<h6>Tworzenie :</h6>
```CREATE database myLocalDb```
```CREATE SCHEMA hardwareRecs```
```CREATE TABLE hardwareRecs.users( Id integer, Reputation integer, CreationDate date, DisplayName varchar, LastAccessDate date, AboutMe varchar, Views integer, UpVotes integer, DownVotes integer, ProfileImageUrl varchar, Age integer, AccountId varchar)```

<h6>Czas importowania</h6>
```2,021s```

<h6>Liczba danych</h6>
```SELECT COUNT(*) FROM hardwareRecs.users```
Output: ```4583```
Czas: ```0,003271s```

<h6>Agregacja 1. 3 ostatnio dodanych użytkowników</h6>

```
SELECT DisplayName, CreationDate 
FROM hardwareRecs.users 
ORDER BY CreationDate 
ASC LIMIT 3;
```
Czas: ```0,005271s```

<h6>Output</h6>
<br>
<table>
  <thead>
    <tr>
      <th>DisplayName</th>
      <th>CreationDate</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <td>Mick</td>
      <td>2017-03-13T20:30:44.930</td>
    </tr>
    <tr>
      <td>ADSquared</td>
      <td>2017-03-13T20:20:28.823</td>
    </tr>
    <tr>
      <td>Mark</td>
      <td>2017-03-13T20:13:23.037</td>
    </tr>
 </tbody>
</table>
