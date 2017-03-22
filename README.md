# Technologie NoSQL

## Artur Koliński

Wybrany zbiór danych 2.1Gb - [National Statistics Postcode Lookup UK](http://geoportal.statistics.gov.uk/datasets/055c2d8135ca4297a85d624bb68aefdb_0.geojson)

| Nazwa | Wartosć    |
|-----------------------|------------|
| Procesor | i5-6600K CPU 4 x 3,7 GHz |
| RAM | 16 GB |
| Dysk | SSD |
| System operacyjny | Windows 10 64-bit |

# Zaliczenie:

## Zadanie GEO
[Zadanie GEO](https://artkolinski.github.io/NoSQL/) 

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

## Elasticsearch

1. Użycie funkcji geo_distance, aby uzyskać 40 adresów w promieniu 460m od [-2.136929,57.127335]
```
curl -XGET "http://localhost:9200/postcodes/_search?size=40&pretty=1" -d"
{
    \"query\": {
       \"bool\": {
           \"must\": {
              \"match_all\": {}
           },
           \"filter\" : {
               \"geo_distance\" : {
                   \"distance\" : \"0.46km\",
                   \"geometry.coordinates\" : [-2.136929,57.127335]
               }
           }
       }
   }
}" | jq .hits.hits > mapa1.json
```
[Mapa 1](https://github.com/artkolinski/NoSQL/blob/master/mapa1.geojson) 


2. Użycie funkcji geo_polygon, aby uzyskać 2000 adresów z wielokąta ograniczonego punktami geo :
```
curl -XGET "http://localhost:9200/postcodes/_search?size=2000&pretty=1" -d"
{
    \"query\": {
        \"bool\" : {
            \"must\" : {
                \"match_all\": { }
            },
            \"filter\" : {
                \"geo_polygon\" : {
                    \"geometry.coordinates\" : {
                        \"points\" : [
				[-2.13596,57.133292],
				[-2.211569,57.103777],
				[-2.270626,57.132427],
				[-2.274715,57.182588]
                        ]
                    }
                }
            }
        }
    }
}"
| jq .hits.hits > mapa2.json
```
[Mapa 2](https://github.com/artkolinski/NoSQL/blob/master/mapa2.geojson) 


Skrypt przetwarzający json na geojson : [Skrypt](https://github.com/artkolinski/NoSQL/blob/master/jsonToGeojson.py) 

## PostgreSQL

### Zadanie 1

Dane: [Hardware Recs](https://archive.org/download/stackexchange/hardwarerecs.stackexchange.com.7z)

Plik: Users.xml

#### Konwertujemy Users.xml do csv i otrzymujemy tabele :

#### users.csv 

|Id|Reputation|CreationDate|DisplayName|LastAccessDate|AboutMe|Views|UpVotes|DownVotes|ProfileImageUrl|Age|AccountId|
|---|----------------|------|------------|------------|------|--------|--------|--------|--------|--------|--------|

<h6>Połączenie z postgresem</h6>

```
psql -U postgres -h localhost
```

<h6>Uruchomienie mierzenia czasu</h6>

```
\timing
```

<h6>Tworzenie :</h6>

```
CREATE database myLocalDb
CREATE SCHEMA hardwareRecs
CREATE TABLE hardwareRecs.users( Id integer, Reputation integer, CreationDate date, DisplayName varchar, LastAccessDate date, AboutMe varchar, Views integer, UpVotes integer, DownVotes integer, ProfileImageUrl varchar, Age integer, AccountId varchar)
```

<h6>Czas importowania</h6>

```
2,021s
```

<h6>Liczba danych</h6>

```
SELECT COUNT(*) FROM hardwareRecs.users
Output: 4583
Czas: 0,003271s
```

<h4>Agregacja 1. 5 ostatnio dodanych użytkowników</h4>

```
SELECT DisplayName, CreationDate 
FROM hardwareRecs.users 
ORDER BY CreationDate 
ASC LIMIT 5;
```
Czas:
```
0,005271s
```

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
    <tr>
      <td>Keshav Srinivasan</td>
      <td>2017-03-13T19:44:51.630</td>
    </tr>
    <tr>
      <td>GµårÐïåñ</td>
      <td>2017-03-13T19:42:39.580</td>
    </tr>
 </tbody>
</table>

<h4>Agregacja 2. 5 użytkowników którzy głosowali min. 100 razy pozytywnie i odwiedziło ich ponad 25 osób</h4>

```
SELECT DisplayName, Views, UpVotes
FROM hardwareRecs.users 
WHERE Views > 25 AND UpVotes > 100
LIMIT 5;
```
Czas:
```
0,011271s
```

<h6>Output</h6>
<br>
<table>
  <thead>
    <tr>
      <th>DisplayName</th>
      <th>Views</th>
      <th>UpVotes</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <td>ArtOfCode</td>
      <td>185</td>
      <td>695</td>
    </tr>
    <tr>
      <td>Adam</td>
      <td>84</td>
      <td>781</td>
    </tr>
    <tr>
      <td>Undo</td>
      <td>73</td>
      <td>254</td>
    </tr>
    <tr>
      <td>Andy</td>
      <td>56</td>
      <td>496</td>
    </tr>
    <tr>
      <td>RubyJunk</td>
      <td>29</td>
      <td>107</td>
    </tr>
 </tbody>
</table>

<h4>Agregacja 3. 5 użytkowników którzy mają conajmniej 50 lat i głosowali</h4>

```
SELECT DisplayName, UpVotes, Age
FROM hardwareRecs.users 
WHERE Age >= 50 AND UpVotes != 0
LIMIT 5;
```
Czas:
```
0,0163s
```

<h6>Output</h6>
<br>
<table>
  <thead>
    <tr>
      <th>DisplayName</th>
      <th>UpVotes</th>
      <th>Age</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <td>Criggie</td>
      <td>13</td>
      <td>97
</td>
    </tr>
    <tr>
      <td>leeand00</td>
      <td>2</td>
      <td>97
</td>
    </tr>
    <tr>
      <td>S Blas</td>
      <td>1</td>
      <td>97
</td>
    </tr>
    <tr>
      <td>stannius</td>
      <td>1</td>
      <td>88
</td>
    </tr>
    <tr>
      <td>Mick</td>
      <td>1</td>
      <td>66</td>
    </tr>
 </tbody>
</table>
