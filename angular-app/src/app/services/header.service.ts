import {Injectable} from '@angular/core';
import {BehaviorSubject} from 'rxjs/BehaviorSubject';
import {Observable} from 'rxjs/Observable';
import {UserClass} from './json.service';

@Injectable()
export class HeaderService {
  private selectionState = new BehaviorSubject<any>(new UserClass());

  setState(state: any) {
    this.selectionState.next(state);
  }

  getState(): Observable<any> {
    return this.selectionState.asObservable();
  }
}
